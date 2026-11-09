package com.saisa.inventory.api.dto;

import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;

public record CreateItemRequest(
    @NotBlank String sku,
    @NotBlank String name,
    String description,
    String unitOfMeasure,
    String hsnCode,
    Boolean tracksInventory,
    BigDecimal salePrice,
    BigDecimal purchasePrice,
    BigDecimal reorderLevel
) {}

