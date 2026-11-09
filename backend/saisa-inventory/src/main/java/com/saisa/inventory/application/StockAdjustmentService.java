package com.saisa.inventory.application;

import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.domain.account.SystemAccountCode;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import com.saisa.inventory.domain.item.Item;
import com.saisa.inventory.domain.movement.MovementType;
import com.saisa.inventory.domain.movement.StockBalance;
import com.saisa.inventory.domain.movement.StockMovement;
import com.saisa.inventory.infrastructure.persistence.ItemRepository;
import com.saisa.inventory.infrastructure.persistence.StockBalanceRepository;
import com.saisa.inventory.infrastructure.persistence.StockMovementRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Manual stock adjustments:
 *   ADJUSTMENT_IN  -> add stock (e.g., found, count correction up)
 *   ADJUSTMENT_OUT -> remove stock (e.g., damaged, theft, count correction down)
 *
 * Both post journal entries:
 *   ADJUSTMENT_IN:  Inventory Asset Dr / Inventory Adjustment Gain Cr
 *   ADJUSTMENT_OUT: Inventory Adjustment Loss Dr / Inventory Asset Cr
 */
@Service
public class StockAdjustmentService {

    private static final Logger log = LoggerFactory.getLogger(StockAdjustmentService.class);

    private final ItemRepository itemRepo;
    private final StockBalanceRepository balanceRepo;
    private final StockMovementRepository movementRepo;
    private final JournalPostingService postingService;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;

    public StockAdjustmentService(
            ItemRepository itemRepo,
            StockBalanceRepository balanceRepo,
            StockMovementRepository movementRepo,
            JournalPostingService postingService,
            ChartOfAccountRepository accountRepo,
            AccountingPeriodRepository periodRepo) {
        this.itemRepo = itemRepo;
        this.balanceRepo = balanceRepo;
        this.movementRepo = movementRepo;
        this.postingService = postingService;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
    }

    public record AdjustmentRequest(
        Long tenantId,
        Long itemId,
        Long warehouseId,
        LocalDate date,
        String type,               // ADJUSTMENT_IN or ADJUSTMENT_OUT
        BigDecimal quantity,
        BigDecimal unitCost,        // null -> use current WAC (for OUT); for IN, must provide
        String notes,
        Long userId
    ) {}

    public record AdjustmentResult(
        StockMovement movement,
        BigDecimal wacAfter,
        BigDecimal totalValue,
        JournalEntry journalEntry
    ) {}

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public AdjustmentResult adjust(AdjustmentRequest req) {
        Item item = itemRepo.findById(req.itemId())
            .orElseThrow(() -> new InvalidJournalEntryException("Item not found"));
        if (!item.getTenantId().equals(req.tenantId())) {
            throw new InvalidJournalEntryException("Item not found");
        }
        if (!item.isTracksInventory()) {
            throw new InvalidJournalEntryException("Item does not track inventory");
        }

        if ("ADJUSTMENT_IN".equals(req.type())) {
            return adjustmentIn(req, item);
        } else if ("ADJUSTMENT_OUT".equals(req.type())) {
            return adjustmentOut(req, item);
        } else {
            throw new InvalidJournalEntryException("Invalid adjustment type: " + req.type());
        }
    }

    private AdjustmentResult adjustmentIn(AdjustmentRequest req, Item item) {
        if (req.unitCost() == null || req.unitCost().signum() <= 0) {
            throw new InvalidJournalEntryException("Unit cost required for ADJUSTMENT_IN");
        }

        StockBalance balance = balanceRepo.findForUpdate(req.tenantId(), req.itemId(), req.warehouseId())
            .orElseGet(() -> createEmptyBalance(req.tenantId(), req.itemId(), req.warehouseId()));

        BigDecimal qty = req.quantity();
        BigDecimal cost = req.unitCost();
        BigDecimal totalValue = qty.multiply(cost).setScale(4, RoundingMode.HALF_EVEN);
        BigDecimal newQty = balance.getQuantityOnHand().add(qty);
        BigDecimal newValue = balance.getInventoryValue().add(totalValue);
        BigDecimal newWac = newQty.signum() > 0
            ? newValue.divide(newQty, 4, RoundingMode.HALF_EVEN)
            : cost;

        StockMovement mv = new StockMovement();
        mv.setTenantId(req.tenantId());
        mv.setItemId(req.itemId());
        mv.setWarehouseId(req.warehouseId());
        mv.setMovementType(MovementType.ADJUSTMENT_IN);
        mv.setMovementDate(req.date());
        mv.setQuantityIn(qty);
        mv.setQuantityOut(BigDecimal.ZERO);
        mv.setUnitCost(cost);
        mv.setTotalValue(totalValue);
        mv.setWacAfter(newWac);
        mv.setNotes(req.notes());
        mv.setCreatedBy(req.userId());
        movementRepo.save(mv);

        balance.setQuantityOnHand(newQty);
        balance.setInventoryValue(newValue);
        balance.setWac(newWac);
        balance.setUpdatedAt(Instant.now());
        balanceRepo.save(balance);

        // Journal: Inventory Asset Dr / Inventory Adjustment Gain Cr
        JournalEntry journal = postAdjustmentJournal(req, item, "ADJUSTMENT_IN", totalValue);
        log.info("Stock ADJUSTMENT_IN recorded: item={}, qty={}, newWac={}, journalId={}",
            item.getSku(), qty, newWac, journal.getId());

        return new AdjustmentResult(mv, newWac, totalValue, journal);
    }

    private AdjustmentResult adjustmentOut(AdjustmentRequest req, Item item) {
        StockBalance balance = balanceRepo.findForUpdate(req.tenantId(), req.itemId(), req.warehouseId())
            .orElseThrow(() -> new InvalidJournalEntryException("No stock record for item " + item.getSku()));

        if (balance.getQuantityOnHand().compareTo(req.quantity()) < 0) {
            throw new InvalidJournalEntryException(
                "Insufficient stock: have " + balance.getQuantityOnHand() + ", need " + req.quantity());
        }

        BigDecimal qty = req.quantity();
        BigDecimal wacUsed = balance.getWac();
        BigDecimal totalValue = qty.multiply(wacUsed).setScale(4, RoundingMode.HALF_EVEN);
        BigDecimal newQty = balance.getQuantityOnHand().subtract(qty);
        BigDecimal newValue = balance.getInventoryValue().subtract(totalValue);
        BigDecimal wacAfter = newQty.signum() > 0 ? wacUsed : BigDecimal.ZERO;

        StockMovement mv = new StockMovement();
        mv.setTenantId(req.tenantId());
        mv.setItemId(req.itemId());
        mv.setWarehouseId(req.warehouseId());
        mv.setMovementType(MovementType.ADJUSTMENT_OUT);
        mv.setMovementDate(req.date());
        mv.setQuantityIn(BigDecimal.ZERO);
        mv.setQuantityOut(qty);
        mv.setUnitCost(wacUsed);
        mv.setTotalValue(totalValue);
        mv.setWacAfter(wacAfter);
        mv.setNotes(req.notes());
        mv.setCreatedBy(req.userId());
        movementRepo.save(mv);

        balance.setQuantityOnHand(newQty);
        balance.setInventoryValue(newValue);
        balance.setWac(wacAfter);
        balance.setUpdatedAt(Instant.now());
        balanceRepo.save(balance);

        // Journal: Inventory Adjustment Loss Dr / Inventory Asset Cr
        JournalEntry journal = postAdjustmentJournal(req, item, "ADJUSTMENT_OUT", totalValue);
        log.info("Stock ADJUSTMENT_OUT recorded: item={}, qty={}, wacUsed={}, journalId={}",
            item.getSku(), qty, wacUsed, journal.getId());

        return new AdjustmentResult(mv, wacAfter, totalValue, journal);
    }

    private JournalEntry postAdjustmentJournal(
            AdjustmentRequest req, Item item, String type,
            BigDecimal amount) {

        Long adjustmentGainId = requireAccount(req.tenantId(), SystemAccountCode.INVENTORY_GAIN);
        Long adjustmentLossId = requireAccount(req.tenantId(), SystemAccountCode.INVENTORY_LOSS);
        Long inventoryAssetId = requireAccount(req.tenantId(), SystemAccountCode.INVENTORY_ASSET);
        Long periodId = requirePeriod(req.tenantId(), req.date());

        Currency currency = Currency.INR;
        Money amt = Money.of(amount, currency);

        JournalEntryBuilder b = JournalEntryBuilder.create()
            .tenant(req.tenantId())
            .entryDate(req.date())
            .period(periodId)
            .type(EntryType.ADJUSTMENT)
            .description("Stock " + (type.equals("ADJUSTMENT_IN") ? "gain" : "loss")
                + " — " + item.getSku() + " — " + (req.notes() != null ? req.notes() : ""))
            .reference("STOCK_ADJUSTMENT", null)
            .idempotencyKey("STOCK_ADJ:" + req.itemId() + ":" + System.nanoTime())
            .createdBy(req.userId());

        if (type.equals("ADJUSTMENT_IN")) {
            b.debit(inventoryAssetId, amt, "Inventory increased");
            b.credit(adjustmentGainId, amt, "Adjustment gain");
        } else {
            b.debit(adjustmentLossId, amt, "Adjustment loss");
            b.credit(inventoryAssetId, amt, "Inventory decreased");
        }

        return postingService.post(b.build(), req.userId());
    }

    private StockBalance createEmptyBalance(Long tenantId, Long itemId, Long warehouseId) {
        StockBalance b = new StockBalance();
        b.setTenantId(tenantId);
        b.setItemId(itemId);
        b.setWarehouseId(warehouseId);
        b.setQuantityOnHand(BigDecimal.ZERO);
        b.setWac(BigDecimal.ZERO);
        b.setInventoryValue(BigDecimal.ZERO);
        b.setUpdatedAt(Instant.now());
        return balanceRepo.save(b);
    }

    private Long requireAccount(Long tenantId, String code) {
        return accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account '" + code + "' missing for tenant " + tenantId))
            .getId();
    }

    private Long requirePeriod(Long tenantId, LocalDate date) {
        AccountingPeriod p = periodRepo.findActivePeriodForDate(tenantId, date)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open accounting period for date " + date));
        return p.getId();
    }
}

