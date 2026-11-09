package com.saisa.financial.application.reporting.dto;

import com.saisa.financial.domain.money.Money;
import java.time.LocalDate;
import java.util.List;

/**
 * Cash Flow Statement (simplified - Direct Method).
 *
 * Rather than the full Indirect Method (which adjusts net income for
 * non-cash items like depreciation), we start with a simpler Direct Method:
 * track every movement of the Cash and Bank accounts.
 *
 * Categories:
 *   OPERATING  - day-to-day business (sales receipts, expense payments)
 *   INVESTING  - purchase/sale of assets
 *   FINANCING  - loans, equity injections, dividends
 *
 * For the first iteration, we classify by ENTRY_TYPE which is set by
 * the posting source (SALES, PURCHASE, RECEIPT, PAYMENT, etc.).
 *
 * A full implementation would have a mapping table, but this gives
 * useful information immediately.
 */
public record CashFlowReport(
    Long tenantId,
    LocalDate fromDate,
    LocalDate toDate,
    Money openingBalance,
    Money closingBalance,
    Money netChange,
    List<CategorySection> categories
) {

    public record CategorySection(
        String category,        // OPERATING, INVESTING, FINANCING
        List<Movement> movements,
        Money netAmount
    ) {}

    public record Movement(
        LocalDate date,
        String entryNumber,
        String narration,
        Money inflow,
        Money outflow
    ) {}
}
