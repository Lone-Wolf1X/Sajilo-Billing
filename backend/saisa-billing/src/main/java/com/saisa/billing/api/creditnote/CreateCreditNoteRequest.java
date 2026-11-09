package com.saisa.billing.api.creditnote;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

public record CreateCreditNoteRequest(
    @NotBlank String creditNoteNumber,
    @NotNull LocalDate creditNoteDate,
    @NotNull Long customerId,
    Long originalInvoiceId,
    String reason,
    String idempotencyKey,
    @NotEmpty @Valid List<LineRequest> lines
) {
    public record LineRequest(
        Long itemId,
        String description,
        @NotNull String quantity,
        @NotNull String unitPrice,
        @NotNull String taxRate
    ) {}
}

