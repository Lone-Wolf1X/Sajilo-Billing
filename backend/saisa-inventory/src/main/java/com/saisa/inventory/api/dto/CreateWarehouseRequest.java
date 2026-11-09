package com.saisa.inventory.api.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateWarehouseRequest(
    @NotBlank String code,
    @NotBlank String name,
    String address,
    Boolean isDefault
) {}

