package com.saisa.financial.application.reporting;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Trial Balance: a list of all accounts with their debit/credit balances
 * at a point in time. Sum of all debit balances MUST equal sum of all credit
 * balances. If not, the ledger is broken.
 *
 * This is the FIRST report any accountant runs after closing a period.
 * It proves double-entry has been maintained.
 */
@Service
@Transactional(readOnly = true)
public class TrialBalanceService {

    @PersistenceContext
    private EntityManager em;

    public record TrialBalanceRow(
        Long accountId,
        String accountCode,
        String accountName,
        String accountType,
        BigDecimal debitBalance,
        BigDecimal creditBalance
    ) {}

    /**
     * Compute trial balance for a tenant at a specific date.
     *
     * For each account, compute SUM(debit) - SUM(credit).
     * If positive -> debit balance (asset/expense typically).
     * If negative -> credit balance (liability/equity/income typically).
     *
     * Accounts with zero movement are EXCLUDED by default (can be included
     * with a flag later).
     */
    public List<TrialBalanceRow> computeTrialBalance(
            Long tenantId, LocalDate asOfDate) {

        String sql = """
            SELECT
                coa.id,
                coa.account_code,
                coa.account_name,
                coa.account_type,
                COALESCE(SUM(jl.debit_amount), 0) - COALESCE(SUM(jl.credit_amount), 0) AS net_signed
            FROM chart_of_accounts coa
            LEFT JOIN journal_lines jl
                ON jl.account_id = coa.id AND jl.tenant_id = coa.tenant_id
            LEFT JOIN journal_entries je
                ON je.id = jl.journal_entry_id
                AND je.status IN ('POSTED', 'REVERSED')
                AND je.entry_date <= :asOfDate
            WHERE coa.tenant_id = :tenantId
              AND (je.id IS NOT NULL OR jl.id IS NULL)
            GROUP BY coa.id, coa.account_code, coa.account_name, coa.account_type
            ORDER BY coa.account_code
            """;

        @SuppressWarnings("unchecked")
        List<Object[]> rows = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("asOfDate", asOfDate)
            .getResultList();

        List<TrialBalanceRow> result = new ArrayList<>(rows.size());
        for (Object[] row : rows) {
            BigDecimal netSigned = (BigDecimal) row[4];
            if (netSigned.signum() == 0) continue;

            BigDecimal debit = netSigned.signum() > 0 ? netSigned : BigDecimal.ZERO;
            BigDecimal credit = netSigned.signum() < 0 ? netSigned.negate() : BigDecimal.ZERO;

            result.add(new TrialBalanceRow(
                ((Number) row[0]).longValue(),
                (String) row[1],
                (String) row[2],
                (String) row[3],
                debit.setScale(4),
                credit.setScale(4)
            ));
        }
        return result;
    }

    /**
     * Verify trial balance is balanced. Should ALWAYS be true for a
     * well-formed ledger. Used as a sanity check in reports and health checks.
     */
    public boolean isBalanced(List<TrialBalanceRow> rows) {
        BigDecimal totalDebit = BigDecimal.ZERO;
        BigDecimal totalCredit = BigDecimal.ZERO;
        for (TrialBalanceRow row : rows) {
            totalDebit = totalDebit.add(row.debitBalance());
            totalCredit = totalCredit.add(row.creditBalance());
        }
        return totalDebit.compareTo(totalCredit) == 0;
    }
}
