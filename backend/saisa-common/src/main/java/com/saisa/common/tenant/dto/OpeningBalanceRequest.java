package com.saisa.common.tenant.dto;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

/**
 * Opening balances as of fiscal-year start date.
 * All amounts as strings for BigDecimal precision (matches journal entry API).
 * Zero values (or omitted) are allowed — user enters only what applies.
 *
 * Cash + Bank + AR + FixedAssets + Investments + OtherAssets 
 *   = AP + Loans + OtherLiabilities + Capital
 *
 * The frontend computes Capital automatically by default, but the caller
 * may override it. Backend validates the equation and rejects unbalanced.
 */
public record OpeningBalanceRequest(
    @NotNull(message = "Opening date is required")
    LocalDate openingDate,

    // Assets
    String cashInHand,          // -> CASH
    String bankBalance,         // -> BANK
    String accountsReceivable,  // -> AR
    String fixedAssets,         // -> FIXED_ASSETS
    String investments,         // -> INVESTMENTS
    String otherAssets,         // -> OTHER_ASSETS

    // Liabilities
    String accountsPayable,     // -> AP
    String bankLoans,           // -> BANK_LOANS
    String otherLiabilities,    // -> OTHER_LIABILITIES

    // Equity (nullable -> auto-computed)
    String capital,             // -> CAPITAL
    String retainedEarnings     // -> RETAINED_EARNINGS (usually 0 for new business)
) {}

