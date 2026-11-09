package com.saisa.common.tenant.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record OpeningStockRequest(
    @NotNull(message = "Opening date is required")
    LocalDate openingDate,

    @NotNull(message = "Warehouse ID is required")
    Long warehouseId,

    @NotEmpty(message = "Lines cannot be empty")
    List<@Valid OpeningStockLine> lines
) {
    public record OpeningStockLine(
        @NotNull(message = "Item ID is required")
        Long itemId,

        @NotNull(message = "Quantity is required")
        @DecimalMin(value = "0.0001", message = "Quantity must be greater than zero")
        BigDecimal quantity,

        @NotNull(message = "Unit cost is required")
        @DecimalMin(value = "0.00", message = "Unit cost cannot be negative")
        BigDecimal unitCost
    ) {}
}

