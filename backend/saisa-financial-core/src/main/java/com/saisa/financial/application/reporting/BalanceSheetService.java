package com.saisa.financial.application.reporting;

import com.saisa.financial.application.reporting.dto.BalanceSheetReport;
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

@Service
@Transactional(readOnly = true)
public class BalanceSheetService {

    @PersistenceContext
    private EntityManager em;

    public BalanceSheetReport generate(Long tenantId, LocalDate asOfDate) {
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
                AND je.entry_date <= :asOfDate
            WHERE coa.tenant_id = :tenantId
              AND (je.id IS NOT NULL OR jl.id IS NULL)
            GROUP BY coa.id, coa.account_code, coa.account_name, coa.account_type
            ORDER BY coa.account_type, coa.account_code
            """;

        @SuppressWarnings("unchecked")
        List<Object[]> rows = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .setParameter("asOfDate", asOfDate)
            .getResultList();

        List<BalanceSheetReport.Line> assets = new ArrayList<>();
        List<BalanceSheetReport.Line> liabilities = new ArrayList<>();
        List<BalanceSheetReport.Line> equity = new ArrayList<>();
        Money totalAssets = Money.zero(Currency.INR);
        Money totalLiabilities = Money.zero(Currency.INR);
        Money totalEquity = Money.zero(Currency.INR);
        Money incomeTotal = Money.zero(Currency.INR);
        Money expenseTotal = Money.zero(Currency.INR);

        for (Object[] row : rows) {
            Long accountId = ((Number) row[0]).longValue();
            String code = (String) row[1];
            String name = (String) row[2];
            String type = (String) row[3];
            Money dr = Money.fromDatabase((BigDecimal) row[4], Currency.INR);
            Money cr = Money.fromDatabase((BigDecimal) row[5], Currency.INR);

            switch (type) {
                case "ASSET" -> {
                    Money amount = dr.subtract(cr);
                    if (!amount.isZero()) {
                        assets.add(new BalanceSheetReport.Line(accountId, code, name, amount));
                        totalAssets = totalAssets.add(amount);
                    }
                }
                case "LIABILITY" -> {
                    Money amount = cr.subtract(dr);
                    if (!amount.isZero()) {
                        liabilities.add(new BalanceSheetReport.Line(accountId, code, name, amount));
                        totalLiabilities = totalLiabilities.add(amount);
                    }
                }
                case "EQUITY" -> {
                    Money amount = cr.subtract(dr);
                    if (!amount.isZero()) {
                        equity.add(new BalanceSheetReport.Line(accountId, code, name, amount));
                        totalEquity = totalEquity.add(amount);
                    }
                }
                case "INCOME" -> incomeTotal = incomeTotal.add(cr.subtract(dr));
                case "EXPENSE" -> expenseTotal = expenseTotal.add(dr.subtract(cr));
                default -> { /* unknown type - should not happen due to DB constraint */ }
            }
        }

        // Current period earnings = income - expense (to date).
        // This is added under Equity because it hasn't been closed yet.
        Money currentEarnings = incomeTotal.subtract(expenseTotal);

        Money totalEquityWithEarnings = totalEquity.add(currentEarnings);
        Money totalLiabilitiesAndEquity = totalLiabilities.add(totalEquityWithEarnings);

        // The accounting equation must hold. Tolerance is zero (exact decimal).
        boolean balanced = totalAssets.equals(totalLiabilitiesAndEquity);

        return new BalanceSheetReport(
            tenantId, asOfDate,
            assets, liabilities, equity,
            totalAssets, totalLiabilities, totalEquity,
            currentEarnings, totalLiabilitiesAndEquity,
            balanced);
    }
}

