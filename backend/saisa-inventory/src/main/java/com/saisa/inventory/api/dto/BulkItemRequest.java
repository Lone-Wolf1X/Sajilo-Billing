package com.saisa.inventory.api.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import java.util.List;

public record BulkItemRequest(
    @NotEmpty(message = "Item list cannot be empty")
    List<@Valid CreateItemRequest> items
) {}

