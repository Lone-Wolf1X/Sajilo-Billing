package com.saisa.inventory.domain.movement;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import lombok.Getter;
import lombok.Setter;

/**
 * Fast-read aggregated current stock state per item and warehouse.
 * Protected with optimistic locking (@Version) and pessimistic locks on updates.
 */
@Entity
@Table(name = "stock_balances")
@Getter
@Setter
public class StockBalance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Version
    @Column(name = "version", nullable = false)
    private Long version = 0L;

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "item_id", nullable = false)
    private Long itemId;

    @Column(name = "warehouse_id", nullable = false)
    private Long warehouseId;

    @Column(name = "quantity_on_hand", nullable = false, precision = 20, scale = 4)
    private BigDecimal quantityOnHand = BigDecimal.ZERO;

    @Column(name = "wac", nullable = false, precision = 20, scale = 4)
    private BigDecimal wac = BigDecimal.ZERO;

    @Column(name = "inventory_value", nullable = false, precision = 20, scale = 4)
    private BigDecimal inventoryValue = BigDecimal.ZERO;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}

