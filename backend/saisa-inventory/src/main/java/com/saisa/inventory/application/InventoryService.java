package com.saisa.inventory.application;

import com.saisa.inventory.domain.exception.InsufficientStockException;
import com.saisa.inventory.domain.item.Item;
import com.saisa.inventory.domain.movement.MovementType;
import com.saisa.inventory.domain.movement.StockBalance;
import com.saisa.inventory.domain.movement.StockMovement;
import com.saisa.inventory.domain.warehouse.Warehouse;
import com.saisa.inventory.infrastructure.persistence.ItemRepository;
import com.saisa.inventory.infrastructure.persistence.StockBalanceRepository;
import com.saisa.inventory.infrastructure.persistence.StockMovementRepository;
import com.saisa.inventory.infrastructure.persistence.WarehouseRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InventoryService {

    private static final Logger log = LoggerFactory.getLogger(InventoryService.class);

    private final ItemRepository itemRepo;
    private final WarehouseRepository warehouseRepo;
    private final StockBalanceRepository balanceRepo;
    private final StockMovementRepository movementRepo;

    public InventoryService(ItemRepository itemRepo,
                            WarehouseRepository warehouseRepo,
                            StockBalanceRepository balanceRepo,
                            StockMovementRepository movementRepo) {
        this.itemRepo = itemRepo;
        this.warehouseRepo = warehouseRepo;
        this.balanceRepo = balanceRepo;
        this.movementRepo = movementRepo;
    }

    public Long resolveWarehouseId(Long tenantId, Long requestedWarehouseId) {
        if (requestedWarehouseId != null) {
            Warehouse wh = warehouseRepo.findById(requestedWarehouseId)
                .filter(w -> w.getTenantId().equals(tenantId) && w.isActive())
                .orElseThrow(() -> new IllegalArgumentException("Invalid warehouse id " + requestedWarehouseId));
            return wh.getId();
        }

        return warehouseRepo.findFirstByTenantIdAndDefaultWarehouseTrue(tenantId)
            .map(Warehouse::getId)
            .or(() -> warehouseRepo.findByTenantIdAndActiveTrue(tenantId).stream().findFirst().map(Warehouse::getId))
            .orElseThrow(() -> new IllegalStateException("No active warehouse found for tenant " + tenantId));
    }

    @Transactional
    public void receiveStock(Long tenantId,
                             Long warehouseId,
                             Long itemId,
                             BigDecimal quantity,
                             BigDecimal unitCost,
                             LocalDate date,
                             String refType,
                             Long refId,
                             String notes,
                             Long userId) {

        // Idempotency check
        if (movementRepo.findFirstByTenantIdAndReferenceTypeAndReferenceIdAndItemId(
                tenantId, refType, refId, itemId).isPresent()) {
            log.info("Stock movement already exists for ref {}:{} item {} - skipping", refType, refId, itemId);
            return;
        }

        Item item = itemRepo.findByTenantIdAndId(tenantId, itemId)
            .orElseThrow(() -> new IllegalArgumentException("Item not found: " + itemId));

        if (!item.isTracksInventory()) {
            log.debug("Item {} does not track inventory - skipping stock movement", item.getSku());
            return;
        }

        Long finalWarehouseId = resolveWarehouseId(tenantId, warehouseId);

        StockBalance balance = balanceRepo.findForUpdate(tenantId, itemId, finalWarehouseId)
            .orElseGet(() -> {
                StockBalance sb = new StockBalance();
                sb.setTenantId(tenantId);
                sb.setItemId(itemId);
                sb.setWarehouseId(finalWarehouseId);
                sb.setQuantityOnHand(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN));
                sb.setWac(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN));
                sb.setInventoryValue(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN));
                sb.setUpdatedAt(Instant.now());
                return sb;
            });

        BigDecimal oldQty = balance.getQuantityOnHand();
        BigDecimal oldValue = balance.getInventoryValue();
        BigDecimal inQty = quantity.setScale(4, RoundingMode.HALF_EVEN);
        BigDecimal inCost = unitCost.setScale(4, RoundingMode.HALF_EVEN);
        BigDecimal inValue = inQty.multiply(inCost).setScale(4, RoundingMode.HALF_EVEN);

        BigDecimal newQty = oldQty.add(inQty);
        BigDecimal newValue = oldValue.add(inValue);
        BigDecimal newWac = newQty.signum() > 0
            ? newValue.divide(newQty, 4, RoundingMode.HALF_EVEN)
            : BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN);

        balance.setQuantityOnHand(newQty);
        balance.setWac(newWac);
        balance.setInventoryValue(newValue);
        balance.setUpdatedAt(Instant.now());
        balanceRepo.save(balance);

        StockMovement sm = new StockMovement();
        sm.setTenantId(tenantId);
        sm.setItemId(itemId);
        sm.setWarehouseId(finalWarehouseId);
        sm.setMovementType(MovementType.PURCHASE_RECEIPT);
        sm.setMovementDate(date);
        sm.setQuantityIn(inQty);
        sm.setQuantityOut(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN));
        sm.setUnitCost(inCost);
        sm.setTotalValue(inValue);
        sm.setWacAfter(newWac);
        sm.setReferenceType(refType);
        sm.setReferenceId(refId);
        sm.setNotes(notes);
        sm.setCreatedAt(Instant.now());
        sm.setCreatedBy(userId);

        movementRepo.save(sm);
        log.info("Received stock: item={}, qty={}, unitCost={}, newWac={}, warehouse={}",
            item.getSku(), inQty, inCost, newWac, finalWarehouseId);
    }

    @Transactional
    public BigDecimal issueStock(Long tenantId,
                                 Long warehouseId,
                                 Long itemId,
                                 BigDecimal quantity,
                                 LocalDate date,
                                 String refType,
                                 Long refId,
                                 String notes,
                                 Long userId) {

        // Idempotency check
        Optional<StockMovement> existing = movementRepo.findFirstByTenantIdAndReferenceTypeAndReferenceIdAndItemId(
            tenantId, refType, refId, itemId);
        if (existing.isPresent()) {
            log.info("Stock movement already exists for ref {}:{} item {} - returning existing COGS", refType, refId, itemId);
            return existing.get().getTotalValue();
        }

        Item item = itemRepo.findByTenantIdAndId(tenantId, itemId)
            .orElseThrow(() -> new IllegalArgumentException("Item not found: " + itemId));

        if (!item.isTracksInventory()) {
            log.debug("Item {} does not track inventory - skipping stock movement", item.getSku());
            return BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN);
        }

        Long finalWarehouseId = resolveWarehouseId(tenantId, warehouseId);

        StockBalance balance = balanceRepo.findForUpdate(tenantId, itemId, finalWarehouseId)
            .orElseThrow(() -> new InsufficientStockException(
                "No stock available for item " + item.getSku() + " in warehouse " + finalWarehouseId));

        BigDecimal issueQty = quantity.setScale(4, RoundingMode.HALF_EVEN);
        if (balance.getQuantityOnHand().compareTo(issueQty) < 0) {
            throw new InsufficientStockException(
                "Insufficient stock for item " + item.getSku() + ": requested " + issueQty + ", available " + balance.getQuantityOnHand());
        }

        BigDecimal wac = balance.getWac();
        BigDecimal cogs = issueQty.multiply(wac).setScale(4, RoundingMode.HALF_EVEN);

        BigDecimal newQty = balance.getQuantityOnHand().subtract(issueQty);
        BigDecimal newValue = balance.getInventoryValue().subtract(cogs);
        if (newQty.compareTo(BigDecimal.ZERO) == 0) {
            newValue = BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN);
        }

        balance.setQuantityOnHand(newQty);
        balance.setInventoryValue(newValue);
        balance.setUpdatedAt(Instant.now());
        balanceRepo.save(balance);

        StockMovement sm = new StockMovement();
        sm.setTenantId(tenantId);
        sm.setItemId(itemId);
        sm.setWarehouseId(finalWarehouseId);
        sm.setMovementType(MovementType.SALE_ISSUE);
        sm.setMovementDate(date);
        sm.setQuantityIn(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_EVEN));
        sm.setQuantityOut(issueQty);
        sm.setUnitCost(wac);
        sm.setTotalValue(cogs);
        sm.setWacAfter(wac);
        sm.setReferenceType(refType);
        sm.setReferenceId(refId);
        sm.setNotes(notes);
        sm.setCreatedAt(Instant.now());
        sm.setCreatedBy(userId);

        movementRepo.save(sm);
        log.info("Issued stock: item={}, qty={}, cogs={}, remainingQty={}, warehouse={}",
            item.getSku(), issueQty, cogs, newQty, finalWarehouseId);

        return cogs;
    }
}

