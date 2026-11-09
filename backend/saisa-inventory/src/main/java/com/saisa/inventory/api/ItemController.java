package com.saisa.inventory.api;

import com.saisa.common.tenant.TenantContext;
import com.saisa.inventory.api.dto.BulkItemRequest;
import com.saisa.inventory.api.dto.BulkItemResponse;
import com.saisa.inventory.api.dto.CreateItemRequest;
import com.saisa.inventory.api.dto.ItemResponse;
import com.saisa.inventory.api.dto.UpdateItemRequest;
import com.saisa.inventory.domain.item.Item;
import com.saisa.inventory.infrastructure.persistence.ItemRepository;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
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

    @PostMapping("/bulk")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    @Transactional
    public ResponseEntity<BulkItemResponse> createBulk(@Valid @RequestBody BulkItemRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        // 1. Check for duplicate SKUs within request
        Set<String> seenSkus = new HashSet<>();
        for (CreateItemRequest itemReq : req.items()) {
            String sku = itemReq.sku().trim();
            if (!seenSkus.add(sku.toLowerCase())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Duplicate SKU in request: " + sku);
            }
        }

        // 2. Check for existing SKUs in database
        for (CreateItemRequest itemReq : req.items()) {
            if (itemRepo.existsByTenantIdAndSku(tenantId, itemReq.sku().trim())) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "Item SKU already exists: " + itemReq.sku());
            }
        }

        // 3. Map and save all items
        List<Item> toSave = req.items().stream().map(itemReq -> {
            Item item = new Item();
            item.setTenantId(tenantId);
            item.setSku(itemReq.sku().trim());
            item.setName(itemReq.name().trim());
            item.setDescription(itemReq.description());
            if (itemReq.unitOfMeasure() != null && !itemReq.unitOfMeasure().isBlank()) {
                item.setUnitOfMeasure(itemReq.unitOfMeasure().trim());
            }
            item.setHsnCode(itemReq.hsnCode());
            if (itemReq.tracksInventory() != null) {
                item.setTracksInventory(itemReq.tracksInventory());
            }
            if (itemReq.salePrice() != null) {
                item.setSalePrice(itemReq.salePrice());
            }
            if (itemReq.purchasePrice() != null) {
                item.setPurchasePrice(itemReq.purchasePrice());
            }
            item.setReorderLevel(itemReq.reorderLevel());
            item.setActive(true);
            item.setCreatedBy(userId);
            return item;
        }).toList();

        List<Item> saved = itemRepo.saveAll(toSave);
        List<ItemResponse> responses = saved.stream().map(ItemResponse::from).toList();
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(new BulkItemResponse(saved.size(), responses));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ItemResponse update(@PathVariable Long id, @Valid @RequestBody UpdateItemRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();

        Item item = itemRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found: " + id));
        if (!item.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found");
        }

        if (req.name() != null) item.setName(req.name());
        if (req.description() != null) item.setDescription(req.description());
        if (req.hsnCode() != null) item.setHsnCode(req.hsnCode());
        if (req.unitOfMeasure() != null && !req.unitOfMeasure().isBlank()) item.setUnitOfMeasure(req.unitOfMeasure());
        if (req.salePrice() != null) item.setSalePrice(req.salePrice());
        if (req.purchasePrice() != null) item.setPurchasePrice(req.purchasePrice());
        if (req.reorderLevel() != null) item.setReorderLevel(req.reorderLevel());
        if (req.active() != null) item.setActive(req.active());

        item.setUpdatedBy(TenantContext.getCurrentUserId());
        Item saved = itemRepo.save(item);

        return ItemResponse.from(saved);
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

