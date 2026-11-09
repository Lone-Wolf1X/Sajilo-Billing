package com.saisa.inventory.api.dto;

import com.saisa.inventory.domain.item.Item;
import java.math.BigDecimal;

public record ItemResponse(
    Long id,
    String sku,
    String name,
    String description,
    String unitOfMeasure,
    String hsnCode,
    boolean tracksInventory,
    BigDecimal salePrice,
    BigDecimal purchasePrice,
    BigDecimal reorderLevel,
    boolean active
) {
    public static ItemResponse from(Item i) {
        return new ItemResponse(
            i.getId(),
            i.getSku(),
            i.getName(),
            i.getDescription(),
            i.getUnitOfMeasure(),
            i.getHsnCode(),
            i.isTracksInventory(),
            i.getSalePrice(),
            i.getPurchasePrice(),
            i.getReorderLevel(),
            i.isActive()
        );
    }
}

