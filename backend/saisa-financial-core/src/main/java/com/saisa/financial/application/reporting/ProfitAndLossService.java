package com.saisa.financial.application.reporting;

import com.saisa.financial.application.reporting.dto.ProfitAndLossReport;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Generates the Profit & Loss statement.
 *
 * The P&L uses accounts where type IN ('INCOME', 'EXPENSE').
 * Each line is shown in its NORMAL direction:
 *   - INCOME accounts (credit-normal): amount = sum(credit) - sum(debit)
 *   - EXPENSE accounts (debit-normal): amount = sum(debit) - sum(credit)
 *
 * This makes "more revenue" and "more expense" both positive numbers,
 * which reads correctly to a non-accountant. Net profit = totalRevenue - totalExpenses.
 */
@Service
@Transactional(readOnly = true)
public class ProfitAndLossService {

    @PersistenceContext
    private EntityManager em;

    public ProfitAndLossReport generate(
            Long tenantId, LocalDate fromDate, LocalDate toDate) {

        String sql = """
            SELECT
                coa.id,
                coa.account_code,
                coa.account_name,
                coa.account_type,
                COALESCE(SUM(jl.debit_amount), 0)  AS total_debit,
                COALESCE(SUM(jl.credit_amount), 0) AS total_credit
            FROM chart_of_accounts coa
            LEFT JOIN journal_lines jl
                ON jl.account_id = coa.id AND jl.tenant_id = coa.tenant_id
            LEFT JOIN journal_entries je
                ON je.id = jl.journal_entry_id
                AND je.status IN ('POSTED', 'REVERSED')
                AND je.entry_date BETWEEN :fromDate AND :toDate
            WHERE coa.tenant_id = :tenantId
              AND coa.account_type IN ('INCOME', 'EXPENSE')
              AND (je.id IS NOT NULL OR jl.id IS NULL)
            GROUP BY coa.id, coa.account_code, coa.account_name, coa.account_type
            ORDER BY coa.account_type DESC, coa.account_code
            """;

        @SuppressWarnings("unchecked")
        List<Object[]> rows = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("fromDate", fromDate)
            .setParameter("toDate", toDate)
            .getResultList();

        List<ProfitAndLossReport.Line> revenue = new ArrayList<>();
        List<ProfitAndLossReport.Line> expenses = new ArrayList<>();
        Money totalRevenue = Money.zero(Currency.INR);
        Money totalExpenses = Money.zero(Currency.INR);

        for (Object[] row : rows) {
            Long accountId = ((Number) row[0]).longValue();
            String code = (String) row[1];
            String name = (String) row[2];
            String type = (String) row[3];
            BigDecimal debit = (BigDecimal) row[4];
            BigDecimal credit = (BigDecimal) row[5];

            Money dr = Money.fromDatabase(debit, Currency.INR);
            Money cr = Money.fromDatabase(credit, Currency.INR);

            if ("INCOME".equals(type)) {
                // Credit-normal: net = credit - debit
                Money amount = cr.subtract(dr);
                if (!amount.isZero()) {
                    revenue.add(new ProfitAndLossReport.Line(accountId, code, name, amount));
                    totalRevenue = totalRevenue.add(amount);
                }
            } else { // EXPENSE
                // Debit-normal: net = debit - credit
                Money amount = dr.subtract(cr);
                if (!amount.isZero()) {
                    expenses.add(new ProfitAndLossReport.Line(accountId, code, name, amount));
                    totalExpenses = totalExpenses.add(amount);
                }
            }
        }

        Money netProfit = totalRevenue.subtract(totalExpenses);

        return new ProfitAndLossReport(
            tenantId, fromDate, toDate,
            revenue, expenses,
            totalRevenue, totalExpenses, netProfit);
    }
}

