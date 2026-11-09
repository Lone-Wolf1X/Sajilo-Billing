package com.saisa.financial.application.reporting;

import com.saisa.financial.application.reporting.dto.CashFlowReport;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class CashFlowService {

    @PersistenceContext
    private EntityManager em;

    private final ChartOfAccountRepository accountRepo;

    public CashFlowService(ChartOfAccountRepository accountRepo) {
        this.accountRepo = accountRepo;
    }

    /**
     * Cash accounts are those with account_code starting with '100' and type ASSET.
     * In a real setup, this would be flagged on the account (is_cash_account).
     * For now, we use a heuristic + the is_system_account flag we already have.
     */
    private List<Long> findCashAccountIds(Long tenantId) {
        String sql = """
            SELECT id FROM chart_of_accounts
            WHERE tenant_id = :tenantId
              AND account_type = 'ASSET'
              AND (account_code LIKE '100%' OR account_name ILIKE '%cash%' OR account_name ILIKE '%bank%')
            """;
        @SuppressWarnings("unchecked")
        List<Number> ids = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .getResultList();
        return ids.stream().map(Number::longValue).toList();
    }

    public CashFlowReport generate(
            Long tenantId, LocalDate fromDate, LocalDate toDate) {

        List<Long> cashIds = findCashAccountIds(tenantId);
        if (cashIds.isEmpty()) {
            return new CashFlowReport(tenantId, fromDate, toDate,
                Money.zero(Currency.INR), Money.zero(Currency.INR),
                Money.zero(Currency.INR), List.of());
        }

        // Opening balance: net cash position the day before fromDate.
        Money openingBalance = computeNetCashBefore(tenantId, cashIds, fromDate);

        // Movements during period.
        String sql = """
            SELECT
                je.entry_date,
                je.entry_number,
                COALESCE(jl.description, je.description),
                je.entry_type,
                jl.debit_amount,
                jl.credit_amount
            FROM journal_lines jl
            JOIN journal_entries je ON je.id = jl.journal_entry_id
            WHERE jl.tenant_id = :tenantId
              AND jl.account_id IN (:cashIds)
              AND je.status IN ('POSTED', 'REVERSED')
              AND je.entry_date BETWEEN :fromDate AND :toDate
            ORDER BY je.entry_date, je.id, jl.line_number
            """;

        @SuppressWarnings("unchecked")
        List<Object[]> rows = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("cashIds", cashIds)
            .setParameter("fromDate", fromDate)
            .setParameter("toDate", toDate)
            .getResultList();

        // Group movements by category (based on entry_type).
        Map<String, List<CashFlowReport.Movement>> byCategory = new LinkedHashMap<>();
        byCategory.put("OPERATING", new ArrayList<>());
        byCategory.put("INVESTING", new ArrayList<>());
        byCategory.put("FINANCING", new ArrayList<>());

        Money totalInflow = Money.zero(Currency.INR);
        Money totalOutflow = Money.zero(Currency.INR);

        for (Object[] row : rows) {
            LocalDate date = ((Date) row[0]).toLocalDate();
            String entryNumber = (String) row[1];
            String narration = (String) row[2];
            String entryType = (String) row[3];
            Money debit = Money.fromDatabase((BigDecimal) row[4], Currency.INR);
            Money credit = Money.fromDatabase((BigDecimal) row[5], Currency.INR);

            Money inflow = debit;
            Money outflow = credit;

            String category = classify(entryType);
            byCategory.get(category).add(
                new CashFlowReport.Movement(date, entryNumber, narration, inflow, outflow));

            totalInflow = totalInflow.add(inflow);
            totalOutflow = totalOutflow.add(outflow);
        }

        List<CashFlowReport.CategorySection> sections = new ArrayList<>();
        for (var entry : byCategory.entrySet()) {
            Money net = Money.zero(Currency.INR);
            for (var m : entry.getValue()) {
                net = net.add(m.inflow()).subtract(m.outflow());
            }
            sections.add(new CashFlowReport.CategorySection(
                entry.getKey(), entry.getValue(), net));
        }

        Money netChange = totalInflow.subtract(totalOutflow);
        Money closingBalance = openingBalance.add(netChange);

        return new CashFlowReport(
            tenantId, fromDate, toDate,
            openingBalance, closingBalance, netChange, sections);
    }

    private String classify(String entryType) {
        if (entryType == null) return "OPERATING";
        return switch (entryType) {
            case "SALES", "PURCHASE", "RECEIPT", "PAYMENT",
                 "CONTRA", "JOURNAL", "ADJUSTMENT", "REVERSAL" -> "OPERATING";
            case "OPENING" -> "FINANCING";
            default -> "OPERATING";
        };
    }

    private Money computeNetCashBefore(Long tenantId, List<Long> cashIds, LocalDate beforeDate) {
        String sql = """
            SELECT
                COALESCE(SUM(jl.debit_amount), 0) - COALESCE(SUM(jl.credit_amount), 0)
            FROM journal_lines jl
            JOIN journal_entries je ON je.id = jl.journal_entry_id
            WHERE jl.tenant_id = :tenantId
              AND jl.account_id IN (:cashIds)
              AND je.status IN ('POSTED', 'REVERSED')
              AND je.entry_date < :beforeDate
            """;
        BigDecimal result = (BigDecimal) em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("cashIds", cashIds)
            .setParameter("beforeDate", beforeDate)
            .getSingleResult();
        return Money.fromDatabase(result, Currency.INR);
    }
}

