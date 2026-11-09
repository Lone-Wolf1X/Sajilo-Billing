package com.saisa.app.api.journal;

import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.JournalLine;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public record JournalEntryResponse(
    Long id,
    String entryNumber,
    LocalDate entryDate,
    Long periodId,
    EntryType entryType,
    EntryStatus status,
    String description,
    String referenceType,
    Long referenceId,
    Long reversalOfId,
    Instant postedAt,
    Long postedBy,
    List<Line> lines
) {

    public record Line(
        Long id,
        Integer lineNumber,
        Long accountId,
        String debit,
        String credit,
        String currency,
        String description
    ) {}

    public static JournalEntryResponse from(JournalEntry e, List<JournalLine> lines) {
        return new JournalEntryResponse(
            e.getId(), e.getEntryNumber(), e.getEntryDate(), e.getPeriodId(),
            e.getEntryType(), e.getStatus(), e.getDescription(),
            e.getReferenceType(), e.getReferenceId(), e.getReversalOfId(),
            e.getPostedAt(), e.getPostedBy(),
            lines.stream().map(JournalEntryResponse::lineFrom).toList()
        );
    }

    private static Line lineFrom(JournalLine l) {
        Currency cur = Currency.valueOf(l.getCurrencyCode());
        Money dr = Money.fromDatabase(l.getDebitAmount(), cur);
        Money cr = Money.fromDatabase(l.getCreditAmount(), cur);
        return new Line(
            l.getId(), l.getLineNumber(), l.getAccountId(),
            dr.getAmount().toPlainString(), cr.getAmount().toPlainString(),
            cur.name(), l.getDescription()
        );
    }
}
