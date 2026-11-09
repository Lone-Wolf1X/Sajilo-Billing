package com.saisa.billing.domain.reconciliation;

public enum AdjustmentType {
    BANK_CHARGE,       // money out (expense)
    INTEREST_CREDIT,   // money in (income)
    CORRECTION_IN,     // money in (fix)
    CORRECTION_OUT     // money out (fix)
}
