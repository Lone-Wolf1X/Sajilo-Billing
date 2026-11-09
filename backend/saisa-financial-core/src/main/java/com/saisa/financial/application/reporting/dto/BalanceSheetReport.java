package com.saisa.financial.application.reporting.dto;

import com.saisa.financial.domain.money.Money;
import java.time.LocalDate;
import java.util.List;

/**
 * Balance Sheet as of a specific date.
 *
 * The accounting equation:
 *   ASSETS = LIABILITIES + EQUITY + (INCOME - EXPENSE)
 *
 * The "(INCOME - EXPENSE)" term is the current-period profit, which is
 * technically "retained earnings" that has not yet been closed to Equity.
 *
 * We show it as a separate line "Current Period Earnings" under Equity,
 * so the Balance Sheet reads intuitively.
 */
public record BalanceSheetReport(
    Long tenantId,
    LocalDate asOfDate,
    List<Line> assets,
    List<Line> liabilities,
    List<Line> equity,
    Money totalAssets,
    Money totalLiabilities,
    Money totalEquity,
    Money currentEarnings,
    Money totalLiabilitiesAndEquity,
    boolean balanced
) {

    public record Line(
        Long accountId,
        String accountCode,
        String accountName,
        Money amount
    ) {}
}

