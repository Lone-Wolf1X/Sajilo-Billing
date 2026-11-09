package com.saisa.inventory.api.dto;

import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public record UpdateItemRequest(
    @Size(max = 255) String name,
    String description,
    @Size(max = 16) String hsnCode,
    @Size(max = 16) String unitOfMeasure,
    BigDecimal salePrice,
    BigDecimal purchasePrice,
    BigDecimal reorderLevel,
    Boolean active
) {}
