package com.saisa.financial.domain.money;

import static org.junit.jupiter.api.Assertions.*;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class MoneyTest {

    @Test
    void testScaleNormalizationAndValueEquality() {
        Money m1 = Money.of("100", Currency.INR);
        Money m2 = Money.of("100.00", Currency.INR);

        // Equals should be value-based, not scale-based
        assertEquals(m1, m2);
        assertEquals(m1.hashCode(), m2.hashCode());
        assertEquals("INR 100.00", m1.toString());
    }

    @Test
    void testUnnecessaryScaleRoundingThrowsException() {
        // 3 decimal places for INR (default scale 2) should throw ArithmeticException
        assertThrows(ArithmeticException.class, () -> Money.of("100.005", Currency.INR));
    }

    @Test
    void testAdditionAndSubtraction() {
        Money m1 = Money.of("250.50", Currency.INR);
        Money m2 = Money.of("49.50", Currency.INR);

        Money sum = m1.add(m2);
        assertEquals(Money.of("300.00", Currency.INR), sum);

        Money diff = m1.subtract(m2);
        assertEquals(Money.of("201.00", Currency.INR), diff);
    }

    @Test
    void testCurrencyMismatchThrowsException() {
        Money inr = Money.of("100.00", Currency.INR);
        Money usd = Money.of("100.00", Currency.USD);

        assertThrows(IllegalArgumentException.class, () -> inr.add(usd));
    }

    @Test
    void testMultiplyWithBankersRounding() {
        Money amount = Money.of("100.00", Currency.INR);
        BigDecimal gstRate = new BigDecimal("0.18");

        Money gst = amount.multiply(gstRate);
        assertEquals(Money.of("18.00", Currency.INR), gst);

        // Half-even test: 2.505 rounded to 2 decimals -> 2.50 (even)
        Money m = Money.of("10.00", Currency.INR);
        Money result = m.multiply(new BigDecimal("0.2505"));
        assertEquals(Money.of("2.50", Currency.INR), result);
    }

    @Test
    void testComparisons() {
        Money low = Money.of("50.00", Currency.INR);
        Money high = Money.of("100.00", Currency.INR);

        assertTrue(high.isGreaterThan(low));
        assertTrue(low.isLessThan(high));
        assertFalse(low.isGreaterThan(high));
        assertTrue(high.isPositive());
        assertFalse(Money.zero(Currency.INR).isPositive());
        assertTrue(Money.zero(Currency.INR).isZero());
    }
}
