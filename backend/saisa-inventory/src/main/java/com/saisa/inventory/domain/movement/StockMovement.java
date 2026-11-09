package com.saisa.inventory.domain.movement;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;

/**
 * Immutable stock ledger entry.
 * Every in/out movement is recorded here for complete auditability.
 */
@Entity
@Table(name = "stock_movements")
@Getter
@Setter
public class StockMovement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "item_id", nullable = false)
    private Long itemId;

    @Column(name = "warehouse_id", nullable = false)
    private Long warehouseId;

    @Enumerated(EnumType.STRING)
    @Column(name = "movement_type", nullable = false, length = 32)
    private MovementType movementType;

    @Column(name = "movement_date", nullable = false)
    private LocalDate movementDate;

    @Column(name = "quantity_in", nullable = false, precision = 20, scale = 4)
    private BigDecimal quantityIn = BigDecimal.ZERO;

    @Column(name = "quantity_out", nullable = false, precision = 20, scale = 4)
    private BigDecimal quantityOut = BigDecimal.ZERO;

    @Column(name = "unit_cost", nullable = false, precision = 20, scale = 4)
    private BigDecimal unitCost;

    @Column(name = "total_value", nullable = false, precision = 20, scale = 4)
    private BigDecimal totalValue;

    @Column(name = "wac_after", nullable = false, precision = 20, scale = 4)
    private BigDecimal wacAfter;

    @Column(name = "reference_type", length = 32)
    private String referenceType;

    @Column(name = "reference_id")
    private Long referenceId;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "created_by")
    private Long createdBy;
}

