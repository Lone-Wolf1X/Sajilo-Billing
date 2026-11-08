package com.saisa.financial.domain.money;

/**
 * Supported currencies. ISO 4217 codes.
 *
 * We start with a small set; adding a currency means also deciding its
 * default scale (2 for most, 0 for JPY, 3 for KWD, etc.).
 */
public enum Currency {

    INR("Indian Rupee", 2),
    USD("US Dollar", 2),
    EUR("Euro", 2),
    GBP("British Pound", 2),
    AED("UAE Dirham", 2);

    private final String displayName;
    private final int defaultScale;

    Currency(String displayName, int defaultScale) {
        this.displayName = displayName;
        this.defaultScale = defaultScale;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getDefaultScale() {
        return defaultScale;
    }
}

