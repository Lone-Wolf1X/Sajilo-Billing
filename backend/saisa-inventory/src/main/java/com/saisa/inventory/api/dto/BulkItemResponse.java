package com.saisa.inventory.api.dto;

import java.util.List;

public record BulkItemResponse(
    int createdCount,
    List<ItemResponse> items
) {}

