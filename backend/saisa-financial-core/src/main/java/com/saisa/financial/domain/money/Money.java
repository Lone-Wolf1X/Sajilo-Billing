package com.saisa.financial.domain.money;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

/**
 * Immutable money value object.
 *
 * WHY THIS CLASS EXISTS:
 *   A raw BigDecimal is dangerous for money because:
 *   1. equals() is scale-sensitive (100.00 != 100.0000 as objects, though compareTo==0)
 *   2. Currency is not tracked
 *   3. Arithmetic loses rounding mode
 *   4. Zeros and negatives need special handling
 *
 * This class enforces:
 *   - Exact decimal arithmetic (never float/double)
 *   - Currency consistency (can't add INR to USD)
 *   - Scale normalization (all values stored at currency's default scale)
 *   - Immutability (all operations return new instances)
 *   - Correct equals/hashCode (value-based, not scale-based)
 */
public final class Money implements Comparable<Money> {

    public static final Money ZERO_INR = new Money(BigDecimal.ZERO, Currency.INR);

    private final BigDecimal amount;
    private final Currency currency;

    private Money(BigDecimal amount, Currency currency) {
        this.currency = Objects.requireNonNull(currency, "Currency cannot be null");
        Objects.requireNonNull(amount, "Amount cannot be null");
        // Normalize scale so that 100, 100.0, 100.00 all become 100.00 for INR.
        this.amount = amount.setScale(currency.getDefaultScale(), RoundingMode.UNNECESSARY);
    }

    // ---- Factory methods ----

    public static Money of(String amount, Currency currency) {
        return new Money(new BigDecimal(amount), currency);
    }

    public static Money of(BigDecimal amount, Currency currency) {
        return new Money(amount, currency);
    }

    public static Money ofInr(String amount) {
        return of(amount, Currency.INR);
    }

    public static Money zero(Currency currency) {
        return new Money(BigDecimal.ZERO, currency);
    }

    /**
     * Used by JPA to reconstruct from DB columns. Callers must ensure the
     * BigDecimal coming in already has the correct scale; we still normalize
     * with RoundingMode.UNNECESSARY which throws if scale was lost.
     */
    public static Money fromDatabase(BigDecimal amount, Currency currency) {
        if (amount == null) {
            return zero(currency);
        }
        return new Money(amount, currency);
    }

    // ---- Accessors ----

    public BigDecimal getAmount() {
        return amount;
    }

    public Currency getCurrency() {
        return currency;
    }

    // ---- Arithmetic ----

    public Money add(Money other) {
        assertSameCurrency(other);
        return new Money(this.amount.add(other.amount), this.currency);
    }

    public Money subtract(Money other) {
        assertSameCurrency(other);
        return new Money(this.amount.subtract(other.amount), this.currency);
    }

    public Money multiply(BigDecimal multiplier) {
        Objects.requireNonNull(multiplier);
        // Explicit rounding mode is mandatory. We use HALF_EVEN (banker's rounding)
        // because it is the standard for financial calculations and avoids bias.
        BigDecimal result = this.amount.multiply(multiplier)
                .setScale(currency.getDefaultScale(), RoundingMode.HALF_EVEN);
        return new Money(result, this.currency);
    }

    public Money multiply(int multiplier) {
        return multiply(BigDecimal.valueOf(multiplier));
    }

    public Money negate() {
        return new Money(this.amount.negate(), this.currency);
    }

    public Money abs() {
        return amount.signum() < 0 ? negate() : this;
    }

    // ---- Comparison ----

    public boolean isZero() {
        return amount.signum() == 0;
    }

    public boolean isPositive() {
        return amount.signum() > 0;
    }

    public boolean isNegative() {
        return amount.signum() < 0;
    }

    public boolean isGreaterThan(Money other) {
        assertSameCurrency(other);
        return this.amount.compareTo(other.amount) > 0;
    }

    public boolean isGreaterThanOrEqual(Money other) {
        assertSameCurrency(other);
        return this.amount.compareTo(other.amount) >= 0;
    }

    public boolean isLessThan(Money other) {
        assertSameCurrency(other);
        return this.amount.compareTo(other.amount) < 0;
    }

    @Override
    public int compareTo(Money other) {
        assertSameCurrency(other);
        return this.amount.compareTo(other.amount);
    }

    private void assertSameCurrency(Money other) {
        if (other == null) {
            throw new IllegalArgumentException("Cannot operate with null Money");
        }
        if (this.currency != other.currency) {
            throw new IllegalArgumentException(
                "Currency mismatch: " + this.currency + " vs " + other.currency);
        }
    }

    // ---- equals / hashCode / toString ----
    // IMPORTANT: We use compareTo, not BigDecimal.equals, because the latter
    // is scale-sensitive. Two Money objects are equal if the underlying value
    // is equal, regardless of original scale, as long as currency matches.

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Money other)) return false;
        return this.currency == other.currency
            && this.amount.compareTo(other.amount) == 0;
    }

    @Override
    public int hashCode() {
        return Objects.hash(amount.stripTrailingZeros(), currency);
    }

    @Override
    public String toString() {
        return currency.name() + " " + amount.toPlainString();
    }
}
