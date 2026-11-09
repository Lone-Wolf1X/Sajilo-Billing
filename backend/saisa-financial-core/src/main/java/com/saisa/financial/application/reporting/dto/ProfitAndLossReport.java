package com.saisa.financial.application.reporting.dto;

import com.saisa.financial.domain.money.Money;
import java.time.LocalDate;
import java.util.List;

/**
 * Profit & Loss statement for a period.
 *
 * Structure:
 *   REVENUE
 *     - Sales                     ₹X
 *     - Other Income              ₹Y
 *   Total Revenue                 ₹(X+Y)
 *
 *   EXPENSES
 *     - Cost of Goods Sold        ₹A
 *     - Salaries                  ₹B
 *     - Rent                      ₹C
 *   Total Expenses                ₹(A+B+C)
 *
 *   NET PROFIT / (LOSS)           ₹(Revenue - Expenses)
 *
 * Each account line shows the account's balance in its NORMAL direction
 * (income: credit-normal, expense: debit-normal). So a revenue account
 * with credits of 10000 shows +10000, and an expense account with debits
 * of 3000 shows +3000. Net profit = totalRevenue - totalExpenses.
 */
public record ProfitAndLossReport(
    Long tenantId,
    LocalDate fromDate,
    LocalDate toDate,
    List<Line> revenueLines,
    List<Line> expenseLines,
    Money totalRevenue,
    Money totalExpenses,
    Money netProfit
) {

    public record Line(
        Long accountId,
        String accountCode,
        String accountName,
        Money amount
    ) {}

    /**
     * Convenience: is the business profitable?
     */
    public boolean isProfitable() {
        return !netProfit.isNegative() && !netProfit.isZero();
    }
}
