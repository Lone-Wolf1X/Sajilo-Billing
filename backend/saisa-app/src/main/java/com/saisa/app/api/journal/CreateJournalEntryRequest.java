package com.saisa.app.api.journal;

import com.saisa.financial.domain.journal.EntryType;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

public record CreateJournalEntryRequest(
    @NotNull LocalDate entryDate,
    @NotNull Long periodId,
    @NotNull EntryType entryType,
    String description,
    String referenceType,
    Long referenceId,
    String idempotencyKey,
    @NotEmpty @Valid List<LineRequest> lines
) {

    public record LineRequest(
        @NotNull Long accountId,
        @NotNull String side,  // "DEBIT" or "CREDIT"
        @NotNull String amount,  // string to preserve precision (parsed as BigDecimal)
        String description
    ) {}
}
