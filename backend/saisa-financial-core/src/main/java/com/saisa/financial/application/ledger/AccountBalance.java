package com.saisa.financial.application.ledger;

import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import java.util.Objects;

/**
 * Represents the state of an account at a point in time.
 *
 * Two amounts are tracked:
 *   - rawDebit:  sum of all debits
 *   - rawCredit: sum of all credits
 *
 * The "net" depends on the account type:
 *   - For ASSET / EXPENSE (normal debit):  net = debit - credit
 *   - For LIABILITY / EQUITY / INCOME (normal credit): net = credit - debit
 *
 * This distinction is FUNDAMENTAL in accounting. A "Cash" account with
 * debit=1000, credit=200 shows net=+800. A "Sales" account with the same
 * raw amounts shows net=-800 (because it's a credit-normal account and
 * having more debits than credits in it means something is wrong).
 *
 * The signed-net sign is: positive = normal side, negative = abnormal side.
 * Reports use this to display values correctly.
 */
public final class AccountBalance {

    private final Money rawDebit;
    private final Money rawCredit;
    private final AccountType accountType;
    private final Currency currency;

    public AccountBalance(Money rawDebit, Money rawCredit, AccountType accountType) {
        Objects.requireNonNull(rawDebit);
        Objects.requireNonNull(rawCredit);
        Objects.requireNonNull(accountType);
        if (rawDebit.getCurrency() != rawCredit.getCurrency()) {
            throw new IllegalArgumentException("Currency mismatch in balance");
        }
        this.rawDebit = rawDebit;
        this.rawCredit = rawCredit;
        this.accountType = accountType;
        this.currency = rawDebit.getCurrency();
    }

    public Money getRawDebit() { return rawDebit; }

    public Money getRawCredit() { return rawCredit; }

    public AccountType getAccountType() { return accountType; }

    public Currency getCurrency() { return currency; }

    /**
     * Net balance in the account's NORMAL direction.
     * Positive means the account is on its normal side (typical).
     * Negative means it's on the abnormal side (unusual; audit might ask).
     */
    public Money getNet() {
        return accountType.hasNormalDebitBalance()
            ? rawDebit.subtract(rawCredit)
            : rawCredit.subtract(rawDebit);
    }

    /**
     * Absolute debit-less-credit. Useful for trial balance where every
     * account is presented as a signed number on a single line.
     */
    public Money getSignedNet() {
        return rawDebit.subtract(rawCredit);
    }

    public boolean isZero() {
        return rawDebit.equals(rawCredit);
    }

    @Override
    public String toString() {
        return "AccountBalance{" +
            "debit=" + rawDebit +
            ", credit=" + rawCredit +
            ", net=" + getNet() +
            ", type=" + accountType +
            '}';
    }
}
