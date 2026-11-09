package com.saisa.financial.domain.account;

/**
 * System account codes. These are STABLE across tenants. Every tenant
 * gets accounts with these codes when they are provisioned.
 *
 * Billing module references these codes - NOT account IDs and NOT account
 * names - so that each tenant can rename accounts without breaking the
 * automatic posting rules.
 */
public final class SystemAccountCode {

    // Balance Sheet
    public static final String ACCOUNTS_RECEIVABLE = "AR";
    public static final String ACCOUNTS_PAYABLE = "AP";
    public static final String INVENTORY_ASSET = "INVENTORY_ASSET";
    public static final String GST_OUTPUT_PAYABLE = "GST_OUTPUT";
    public static final String GST_INPUT_CREDIT = "GST_INPUT";
    public static final String CASH = "CASH";
    public static final String BANK = "BANK";

    // P&L
    public static final String SALES_REVENUE = "SALES";
    public static final String SALES_RETURN = "SALES_RETURN";
    public static final String PURCHASE_EXPENSE = "PURCHASE";
    public static final String PURCHASE_RETURN = "PURCHASE_RETURN";
    public static final String COGS = "COGS";
    public static final String INVENTORY_GAIN = "INVENTORY_GAIN";
    public static final String INVENTORY_LOSS = "INVENTORY_LOSS";
    public static final String BANK_CHARGES = "BANK_CHARGES";
    public static final String INTEREST_INCOME = "INTEREST_INCOME";
    public static final String SUSPENSE = "SUSPENSE";

    // ========== Opening Balance Accounts (Phase 2 Setup) ==========
    public static final String FIXED_ASSETS = "FIXED_ASSETS";
    public static final String INVESTMENTS = "INVESTMENTS";
    public static final String OTHER_ASSETS = "OTHER_ASSETS";
    public static final String BANK_LOANS = "BANK_LOANS";
    public static final String OTHER_LIABILITIES = "OTHER_LIABILITIES";
    public static final String CAPITAL = "CAPITAL";
    public static final String RETAINED_EARNINGS = "RETAINED_EARNINGS";

    private SystemAccountCode() {}
}

