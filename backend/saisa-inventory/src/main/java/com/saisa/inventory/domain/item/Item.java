package com.saisa.inventory.domain.item;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "items")
@Getter
@Setter
public class Item extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "sku", nullable = false, length = 64)
    private String sku;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "unit_of_measure", nullable = false, length = 16)
    private String unitOfMeasure = "NOS";

    @Column(name = "hsn_code", length = 16)
    private String hsnCode;

    @Column(name = "tracks_inventory", nullable = false)
    private boolean tracksInventory = true;

    @Column(name = "sale_price", nullable = false, precision = 20, scale = 4)
    private BigDecimal salePrice = BigDecimal.ZERO;

    @Column(name = "purchase_price", nullable = false, precision = 20, scale = 4)
    private BigDecimal purchasePrice = BigDecimal.ZERO;

    @Column(name = "reorder_level", precision = 20, scale = 4)
    private BigDecimal reorderLevel;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;
}

