package com.saisa.inventory.api.dto;

import jakarta.validation.constraints.Size;

public record UpdateWarehouseRequest(
    @Size(max = 255) String name,
    String address,
    Boolean isDefault,
    Boolean active
) {}

