package com.saisa.financial.domain.journal.builder;

import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.JournalLine;
import com.saisa.financial.domain.money.Money;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Fluent builder for JournalEntry that enforces accounting invariants.
 *
 * INVARIANTS (checked in build()):
 *   1. tenant, entryDate, periodId, entryType must all be set
 *   2. At least 2 lines
 *   3. sum(debits) == sum(credits) EXACTLY (no rounding)
 *   4. Every line has non-zero amount
 *   5. All lines must use the same currency as the entry
 *
 * WHY A BUILDER:
 *   Prevents constructing an unbalanced entry in the first place.
 *   When someone writes:
 *     JournalEntryBuilder.create()...debit(A, 100).credit(B, 90).build();
 *   they get a clear InvalidJournalEntryException at the point of build(),
 *   not later when a DB trigger fires.
 */
public final class JournalEntryBuilder {

    private Long tenantId;
    private LocalDate entryDate;
    private Long periodId;
    private EntryType entryType;
    private String description;
    private String entryNumber;
    private String referenceType;
    private Long referenceId;
    private String idempotencyKey;
    private Long createdBy;

    private final List<PendingLine> lines = new ArrayList<>();

    private JournalEntryBuilder() {}

    public static JournalEntryBuilder create() {
        return new JournalEntryBuilder();
    }

    // ---- Header fields ----

    public JournalEntryBuilder tenant(Long tenantId) {
        this.tenantId = Objects.requireNonNull(tenantId, "tenantId");
        return this;
    }

    public JournalEntryBuilder entryDate(LocalDate date) {
        this.entryDate = Objects.requireNonNull(date, "entryDate");
        return this;
    }

    public JournalEntryBuilder period(Long periodId) {
        this.periodId = Objects.requireNonNull(periodId, "periodId");
        return this;
    }

    public JournalEntryBuilder type(EntryType type) {
        this.entryType = Objects.requireNonNull(type, "entryType");
        return this;
    }

    public JournalEntryBuilder description(String description) {
        this.description = description;
        return this;
    }

    public JournalEntryBuilder entryNumber(String entryNumber) {
        this.entryNumber = entryNumber;
        return this;
    }

    public JournalEntryBuilder reference(String referenceType, Long referenceId) {
        this.referenceType = referenceType;
        this.referenceId = referenceId;
        return this;
    }

    public JournalEntryBuilder idempotencyKey(String key) {
        this.idempotencyKey = key;
        return this;
    }

    public JournalEntryBuilder createdBy(Long userId) {
        this.createdBy = userId;
        return this;
    }

    // ---- Lines ----

    /**
     * Add a debit line. The amount MUST be positive.
     */
    public JournalEntryBuilder debit(Long accountId, Money amount) {
        return addLine(accountId, amount, LineSide.DEBIT, null);
    }

    public JournalEntryBuilder debit(Long accountId, Money amount, String description) {
        return addLine(accountId, amount, LineSide.DEBIT, description);
    }

    /**
     * Add a credit line. The amount MUST be positive.
     */
    public JournalEntryBuilder credit(Long accountId, Money amount) {
        return addLine(accountId, amount, LineSide.CREDIT, null);
    }

    public JournalEntryBuilder credit(Long accountId, Money amount, String description) {
        return addLine(accountId, amount, LineSide.CREDIT, description);
    }

    private JournalEntryBuilder addLine(
            Long accountId, Money amount, LineSide side, String description) {
        Objects.requireNonNull(accountId, "accountId");
        Objects.requireNonNull(amount, "amount");
        if (amount.isNegative()) {
            throw new InvalidJournalEntryException(
                "Line amount cannot be negative. Use the other side (debit/credit) instead.");
        }
        if (amount.isZero()) {
            throw new InvalidJournalEntryException(
                "Line amount cannot be zero. Zero-value lines are meaningless.");
        }
        lines.add(new PendingLine(accountId, amount, side, description));
        return this;
    }

    // ---- Build ----

    public JournalEntry build() {
        validateHeader();
        validateLines();

        JournalEntry entry = new JournalEntry();
        entry.setTenantId(tenantId);
        entry.setEntryDate(entryDate);
        entry.setPeriodId(periodId);
        entry.setEntryType(entryType);
        entry.setDescription(description);
        entry.setReferenceType(referenceType);
        entry.setReferenceId(referenceId);
        entry.setIdempotencyKey(idempotencyKey);
        entry.setCreatedBy(createdBy);

        if (entryNumber == null || entryNumber.isBlank()) {
            entry.setEntryNumber(generateTemporaryNumber());
        } else {
            entry.setEntryNumber(entryNumber);
        }

        for (PendingLine pl : lines) {
            JournalLine line = new JournalLine();
            line.setAccountId(pl.accountId());
            line.setDescription(pl.description());
            if (pl.side() == LineSide.DEBIT) {
                line.setDebit(pl.amount());
            } else {
                line.setCredit(pl.amount());
            }
            entry.addLine(line);
        }

        return entry;
    }

    private void validateHeader() {
        if (tenantId == null) throw new InvalidJournalEntryException("tenantId is required");
        if (entryDate == null) throw new InvalidJournalEntryException("entryDate is required");
        if (periodId == null) throw new InvalidJournalEntryException("periodId is required");
        if (entryType == null) throw new InvalidJournalEntryException("entryType is required");
    }

    private void validateLines() {
        if (lines.size() < 2) {
            throw new InvalidJournalEntryException(
                "A journal entry must have at least 2 lines (debit and credit). Got: " + lines.size());
        }

        // All lines must be in the same currency.
        var currencies = lines.stream().map(l -> l.amount().getCurrency()).distinct().toList();
        if (currencies.size() > 1) {
            throw new InvalidJournalEntryException(
                "All lines must use the same currency. Found: " + currencies);
        }

        // THE central accounting invariant.
        Money totalDebit = Money.zero(currencies.get(0));
        Money totalCredit = Money.zero(currencies.get(0));
        for (PendingLine pl : lines) {
            if (pl.side() == LineSide.DEBIT) {
                totalDebit = totalDebit.add(pl.amount());
            } else {
                totalCredit = totalCredit.add(pl.amount());
            }
        }

        if (!totalDebit.equals(totalCredit)) {
            throw new InvalidJournalEntryException(
                "Journal entry is not balanced. Total debits = " + totalDebit
                    + ", total credits = " + totalCredit);
        }
    }

    private String generateTemporaryNumber() {
        // Placeholder - will be replaced by a proper sequence in the posting service.
        return "TMP-" + System.nanoTime();
    }

    // ---- Internal ----

    private enum LineSide { DEBIT, CREDIT }

    private record PendingLine(Long accountId, Money amount, LineSide side, String description) {}
}

