package com.saisa.financial.domain.journal;

import com.saisa.common.domain.BaseEntity;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PostLoad;
import jakarta.persistence.PostPersist;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

/**
 * A single debit or credit line in a journal entry.
 *
 * Invariant: exactly one of debitAmount or creditAmount is non-zero.
 * This invariant is enforced at DB level (chk_jl_one_side_only) and
 * additionally validated here before persist.
 */
@Entity
@Table(name = "journal_lines")
@Getter
@Setter
public class JournalLine extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "journal_entry_id", nullable = false)
    private JournalEntry journalEntry;

    @Column(name = "line_number", nullable = false)
    private Integer lineNumber;

    @Column(name = "account_id", nullable = false)
    private Long accountId;

    // The DB columns are debit_amount and credit_amount.
    // We expose them as raw BigDecimal columns so Hibernate persists exactly
    // what the DB expects, and provide Money-typed accessors on top.

    @Column(name = "debit_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal debitAmount = BigDecimal.ZERO;

    @Column(name = "credit_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal creditAmount = BigDecimal.ZERO;

    @Column(name = "currency", nullable = false, length = 3)
    private String currencyCode = "INR";

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    // ---- Domain accessors using Money ----

    @Transient
    public Money getDebit() {
        return Money.fromDatabase(debitAmount, Currency.valueOf(currencyCode));
    }

    @Transient
    public Money getCredit() {
        return Money.fromDatabase(creditAmount, Currency.valueOf(currencyCode));
    }

    public void setDebit(Money debit) {
        if (debit.isNegative()) {
            throw new IllegalArgumentException("Debit amount cannot be negative");
        }
        if (!debit.isZero() && creditAmount != null && creditAmount.signum() > 0) {
            throw new IllegalStateException("A line cannot be both debit and credit");
        }
        this.debitAmount = debit.getAmount();
        this.currencyCode = debit.getCurrency().name();
    }

    public void setCredit(Money credit) {
        if (credit.isNegative()) {
            throw new IllegalArgumentException("Credit amount cannot be negative");
        }
        if (!credit.isZero() && debitAmount != null && debitAmount.signum() > 0) {
            throw new IllegalStateException("A line cannot be both debit and credit");
        }
        this.creditAmount = credit.getAmount();
        this.currencyCode = credit.getCurrency().name();
    }

    @PostLoad
    @PostPersist
    void ensureDefaults() {
        if (debitAmount == null)  debitAmount = BigDecimal.ZERO;
        if (creditAmount == null) creditAmount = BigDecimal.ZERO;
        if (currencyCode == null) currencyCode = "INR";
    }
}

