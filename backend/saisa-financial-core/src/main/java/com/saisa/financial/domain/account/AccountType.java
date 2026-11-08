package com.saisa.financial.domain.account;

/**
 * The five fundamental account types in double-entry accounting.
 *
 * Debit/Credit behavior:
 *   ASSET:     debit increases,  credit decreases
 *   EXPENSE:   debit increases,  credit decreases
 *   LIABILITY: credit increases, debit decreases
 *   EQUITY:    credit increases, debit decreases
 *   INCOME:    credit increases, debit decreases
 *
 * This determines normal balance and is used by report generators.
 */
public enum AccountType {

    ASSET(true),      // normal debit balance
    EXPENSE(true),    // normal debit balance
    LIABILITY(false), // normal credit balance
    EQUITY(false),    // normal credit balance
    INCOME(false);    // normal credit balance

    private final boolean normalDebitBalance;

    AccountType(boolean normalDebitBalance) {
        this.normalDebitBalance = normalDebitBalance;
    }

    public boolean hasNormalDebitBalance() {
        return normalDebitBalance;
    }

    public boolean isBalanceSheetType() {
        return this == ASSET || this == LIABILITY || this == EQUITY;
    }

    public boolean isIncomeStatementType() {
        return this == INCOME || this == EXPENSE;
    }
}

