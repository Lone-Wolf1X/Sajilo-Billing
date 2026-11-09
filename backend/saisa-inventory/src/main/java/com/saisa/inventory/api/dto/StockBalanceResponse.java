package com.saisa.inventory.api.dto;

import com.saisa.inventory.domain.movement.StockBalance;
import java.math.BigDecimal;
import java.time.Instant;

public record StockBalanceResponse(
    Long id,
    Long itemId,
    Long warehouseId,
    BigDecimal quantityOnHand,
    BigDecimal wac,
    BigDecimal inventoryValue,
    Instant updatedAt
) {
    public static StockBalanceResponse from(StockBalance b) {
        return new StockBalanceResponse(
            b.getId(),
            b.getItemId(),
            b.getWarehouseId(),
            b.getQuantityOnHand(),
            b.getWac(),
            b.getInventoryValue(),
            b.getUpdatedAt()
        );
    }
}

