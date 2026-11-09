package com.saisa.financial.application.ledger;

import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Reads journal postings and produces GL statements.
 *
 * Uses a native SQL query with a PostgreSQL window function to compute
 * running balance in one round-trip. This is dramatically faster than
 * iterating in Java (which would require loading every line into memory).
 *
 * Query shape:
 *   SELECT date, amount, SUM(amount) OVER (ORDER BY date, entry_id, line_id) as running
 *   FROM journal_lines
 *   WHERE account_id = ? AND tenant_id = ?
 *   ORDER BY date, entry_id, line_id
 */
@Service
@Transactional(readOnly = true)
public class GeneralLedgerService {

    @PersistenceContext
    private EntityManager em;

    private final ChartOfAccountRepository accountRepo;

    public GeneralLedgerService(ChartOfAccountRepository accountRepo) {
        this.accountRepo = accountRepo;
    }

    /**
     * Full GL statement for one account, between two dates (inclusive).
     *
     * Running balance uses the account's normal direction (see AccountBalance).
     * Only POSTED entries are included - DRAFT and REVERSED (the original) are
     * excluded so the statement shows NET reality.
     *
     * Wait - REVERSED entries: we INCLUDE them (they happened). But we also
     * include their reversal. Net effect is zero. If we excluded REVERSED,
     * the reversal entry would show a phantom credit. So: include BOTH.
     */
    public List<LedgerEntry> getStatement(
            Long tenantId, Long accountId, LocalDate fromDate, LocalDate toDate) {

        ChartOfAccount account = accountRepo.findById(accountId)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "Account not found: " + accountId));

        if (!account.getTenantId().equals(tenantId)) {
            throw new InvalidJournalEntryException("Account does not belong to tenant");
        }

        Currency currency = Currency.INR; // single currency for now

        // PostgreSQL window function to compute running balance.
        // We compute SUM(debit - credit) cumulative for the normal-debit logic,
        // then adjust sign at the end based on account type.
        String sql = """
            SELECT
                je.entry_date,
                je.entry_number,
                je.id AS journal_entry_id,
                COALESCE(jl.description, je.description) AS narration,
                jl.debit_amount,
                jl.credit_amount,
                SUM(jl.debit_amount - jl.credit_amount)
                    OVER (ORDER BY je.entry_date, je.id, jl.line_number) AS running_signed
            FROM journal_lines jl
            JOIN journal_entries je ON je.id = jl.journal_entry_id
            WHERE jl.tenant_id = :tenantId
              AND jl.account_id = :accountId
              AND je.status IN ('POSTED', 'REVERSED')
              AND je.entry_date BETWEEN :fromDate AND :toDate
            ORDER BY je.entry_date, je.id, jl.line_number
            """;

        @SuppressWarnings("unchecked")
        List<Object[]> rows = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("accountId", accountId)
            .setParameter("fromDate", fromDate)
            .setParameter("toDate", toDate)
            .getResultList();

        boolean normalDebit = account.getAccountType().hasNormalDebitBalance();
        List<LedgerEntry> result = new ArrayList<>(rows.size());

        for (Object[] row : rows) {
            LocalDate date = ((java.sql.Date) row[0]).toLocalDate();
            String entryNumber = (String) row[1];
            Long entryId = ((Number) row[2]).longValue();
            String narration = (String) row[3];
            BigDecimal debit = (BigDecimal) row[4];
            BigDecimal credit = (BigDecimal) row[5];
            BigDecimal runningSigned = (BigDecimal) row[6];

            Money debitMoney = Money.fromDatabase(debit, currency);
            Money creditMoney = Money.fromDatabase(credit, currency);

            // runningSigned = sum(debit - credit). Normal side:
            //   if account is normal-debit:  runningBalance = runningSigned
            //   if account is normal-credit: runningBalance = -runningSigned
            BigDecimal balanceValue = normalDebit ? runningSigned : runningSigned.negate();
            Money runningBalance = Money.fromDatabase(balanceValue, currency);

            result.add(new LedgerEntry(
                date, entryNumber, entryId, narration,
                debitMoney, creditMoney, runningBalance));
        }

        return result;
    }

    /**
     * Aggregate balance of an account over [fromDate, toDate].
     * Useful for reports that don't need line-by-line detail.
     */
    public AccountBalance getBalance(
            Long tenantId, Long accountId, LocalDate fromDate, LocalDate toDate) {

        ChartOfAccount account = accountRepo.findById(accountId)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "Account not found: " + accountId));

        if (!account.getTenantId().equals(tenantId)) {
            throw new InvalidJournalEntryException("Account does not belong to tenant");
        }

        String sql = """
            SELECT
                COALESCE(SUM(jl.debit_amount), 0),
                COALESCE(SUM(jl.credit_amount), 0)
            FROM journal_lines jl
            JOIN journal_entries je ON je.id = jl.journal_entry_id
            WHERE jl.tenant_id = :tenantId
              AND jl.account_id = :accountId
              AND je.status IN ('POSTED', 'REVERSED')
              AND je.entry_date BETWEEN :fromDate AND :toDate
            """;

        Object[] row = (Object[]) em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("accountId", accountId)
            .setParameter("fromDate", fromDate)
            .setParameter("toDate", toDate)
            .getSingleResult();

        Currency currency = Currency.INR;
        Money debit = Money.fromDatabase((BigDecimal) row[0], currency);
        Money credit = Money.fromDatabase((BigDecimal) row[1], currency);

        return new AccountBalance(debit, credit, account.getAccountType());
    }
}
