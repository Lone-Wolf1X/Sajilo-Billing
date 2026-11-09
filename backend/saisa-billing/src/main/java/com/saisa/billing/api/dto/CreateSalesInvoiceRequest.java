package com.saisa.billing.api.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

public record CreateSalesInvoiceRequest(
    @NotBlank String invoiceNumber,
    @NotNull LocalDate invoiceDate,
    LocalDate dueDate,
    @NotNull Long customerId,
    Long warehouseId,
    String notes,
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
