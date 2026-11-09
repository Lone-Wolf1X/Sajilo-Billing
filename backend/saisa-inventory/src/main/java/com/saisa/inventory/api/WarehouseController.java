package com.saisa.inventory.api;

import com.saisa.common.tenant.TenantContext;
import com.saisa.inventory.api.dto.CreateWarehouseRequest;
import com.saisa.inventory.api.dto.UpdateWarehouseRequest;
import com.saisa.inventory.api.dto.WarehouseResponse;
import com.saisa.inventory.domain.warehouse.Warehouse;
import com.saisa.inventory.infrastructure.persistence.WarehouseRepository;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/warehouses")
public class WarehouseController {

    private final WarehouseRepository warehouseRepo;

    public WarehouseController(WarehouseRepository warehouseRepo) {
        this.warehouseRepo = warehouseRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<WarehouseResponse> create(@Valid @RequestBody CreateWarehouseRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (warehouseRepo.existsByTenantIdAndCode(tenantId, req.code())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Warehouse code already exists");
        }

        Warehouse wh = new Warehouse();
        wh.setTenantId(tenantId);
        wh.setCode(req.code());
        wh.setName(req.name());
        wh.setAddress(req.address());
        if (req.isDefault() != null) {
            wh.setDefaultWarehouse(req.isDefault());
        }
        wh.setActive(true);
        wh.setCreatedBy(userId);

        Warehouse saved = warehouseRepo.save(wh);
        return ResponseEntity.status(HttpStatus.CREATED).body(WarehouseResponse.from(saved));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public WarehouseResponse update(@PathVariable Long id, @Valid @RequestBody UpdateWarehouseRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();

        Warehouse wh = warehouseRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Warehouse not found"));
        if (!wh.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Warehouse not found");
        }

        if (req.name() != null) wh.setName(req.name());
        if (req.address() != null) wh.setAddress(req.address());
        if (req.isDefault() != null) wh.setDefaultWarehouse(req.isDefault());
        if (req.active() != null) wh.setActive(req.active());

        wh.setUpdatedBy(TenantContext.getCurrentUserId());
        Warehouse saved = warehouseRepo.save(wh);
        return WarehouseResponse.from(saved);
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<WarehouseResponse> list() {
        Long tenantId = TenantContext.getCurrentTenantId();
        return warehouseRepo.findByTenantIdAndActiveTrue(tenantId).stream()
            .map(WarehouseResponse::from)
            .toList();
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public WarehouseResponse get(@PathVariable Long id) {
        Warehouse wh = warehouseRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Warehouse not found"));
        if (!wh.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Warehouse not found");
        }
        return WarehouseResponse.from(wh);
    }
}

