package com.saisa.inventory.api;

import com.saisa.common.tenant.TenantContext;
import com.saisa.inventory.api.dto.CreateItemRequest;
import com.saisa.inventory.api.dto.ItemResponse;
import com.saisa.inventory.domain.item.Item;
import com.saisa.inventory.infrastructure.persistence.ItemRepository;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/items")
public class ItemController {

    private final ItemRepository itemRepo;

    public ItemController(ItemRepository itemRepo) {
        this.itemRepo = itemRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<ItemResponse> create(@Valid @RequestBody CreateItemRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (itemRepo.existsByTenantIdAndSku(tenantId, req.sku())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Item SKU already exists");
        }

        Item item = new Item();
        item.setTenantId(tenantId);
        item.setSku(req.sku());
        item.setName(req.name());
        item.setDescription(req.description());
        if (req.unitOfMeasure() != null && !req.unitOfMeasure().isBlank()) {
            item.setUnitOfMeasure(req.unitOfMeasure());
        }
        item.setHsnCode(req.hsnCode());
        if (req.tracksInventory() != null) {
            item.setTracksInventory(req.tracksInventory());
        }
        if (req.salePrice() != null) {
            item.setSalePrice(req.salePrice());
        }
        if (req.purchasePrice() != null) {
            item.setPurchasePrice(req.purchasePrice());
        }
        item.setReorderLevel(req.reorderLevel());
        item.setActive(true);
        item.setCreatedBy(userId);

        Item saved = itemRepo.save(item);
        return ResponseEntity.status(HttpStatus.CREATED).body(ItemResponse.from(saved));
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<ItemResponse> list() {
        Long tenantId = TenantContext.getCurrentTenantId();
        return itemRepo.findByTenantIdAndActiveTrueOrderBySku(tenantId).stream()
            .map(ItemResponse::from)
            .toList();
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public ItemResponse get(@PathVariable Long id) {
        Item item = itemRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));
        if (!item.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found");
        }
        return ItemResponse.from(item);
    }
}

