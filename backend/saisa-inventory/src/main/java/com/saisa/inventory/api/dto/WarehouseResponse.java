package com.saisa.inventory.api.dto;

import com.saisa.inventory.domain.warehouse.Warehouse;

public record WarehouseResponse(
    Long id,
    String code,
    String name,
    String address,
    boolean isDefault,
    boolean active
) {
    public static WarehouseResponse from(Warehouse w) {
        return new WarehouseResponse(
            w.getId(),
            w.getCode(),
            w.getName(),
            w.getAddress(),
            w.isDefaultWarehouse(),
            w.isActive()
        );
    }
}

