package com.saisa.app.setup;

import com.saisa.common.audit.AuditLogService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.tenant.dto.OpeningStockRequest;
import com.saisa.common.tenant.dto.OpeningStockResponse;
import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.account.SystemAccountCode;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.JournalLine;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
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
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OpeningStockService {

    private static final Logger log = LoggerFactory.getLogger(OpeningStockService.class);
    private static final String REFERENCE_TYPE = "OPENING_STOCK";

    private final TenantRepository tenantRepo;
    private final WarehouseRepository warehouseRepo;
    private final ItemRepository itemRepo;
    private final StockMovementRepository movementRepo;
    private final StockBalanceRepository balanceRepo;
    private final JournalPostingService postingService;
    private final JournalEntryRepository journalRepo;
    private final AccountingPeriodRepository periodRepo;
    private final ChartOfAccountRepository accountRepo;
    private final AuditLogService auditLog;

    public OpeningStockService(
            TenantRepository tenantRepo,
            WarehouseRepository warehouseRepo,
            ItemRepository itemRepo,
            StockMovementRepository movementRepo,
            StockBalanceRepository balanceRepo,
            JournalPostingService postingService,
            JournalEntryRepository journalRepo,
            AccountingPeriodRepository periodRepo,
            ChartOfAccountRepository accountRepo,
            AuditLogService auditLog) {
        this.tenantRepo = tenantRepo;
        this.warehouseRepo = warehouseRepo;
        this.itemRepo = itemRepo;
        this.movementRepo = movementRepo;
        this.balanceRepo = balanceRepo;
        this.postingService = postingService;
        this.journalRepo = journalRepo;
        this.periodRepo = periodRepo;
        this.accountRepo = accountRepo;
        this.auditLog = auditLog;
    }

    @Transactional(readOnly = true)
    public Optional<JournalEntry> findActiveOpeningStockEntry(Long tenantId) {
        return journalRepo.findByTenantIdAndReferenceWithLines(tenantId, REFERENCE_TYPE, 0L)
            .stream()
            .filter(j -> j.getEntryType() == EntryType.OPENING && j.getStatus() == EntryStatus.POSTED)
            .findFirst();
    }

    @Transactional(readOnly = true)
    public OpeningStockResponse getCurrent(Long tenantId) {
        Optional<JournalEntry> optJe = findActiveOpeningStockEntry(tenantId);
        if (optJe.isEmpty()) {
            return new OpeningStockResponse(
                false, null, null, null, null, 0, BigDecimal.ZERO, BigDecimal.ZERO);
        }

        JournalEntry je = optJe.get();
        BigDecimal totalVal = je.getLines().stream()
            .map(JournalLine::getDebitAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Fetch balances to compute total quantity and item count
        List<StockBalance> balances = balanceRepo.findByTenantId(tenantId);
        BigDecimal totalQty = balances.stream()
            .map(StockBalance::getQuantityOnHand)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        return new OpeningStockResponse(
            true,
            je.getId(),
            je.getEntryNumber(),
            je.getEntryDate(),
            null,
            balances.size(),
            totalQty,
            totalVal
        );
    }

    @Transactional
    public OpeningStockResponse post(Long tenantId, OpeningStockRequest req, Long userId) {
        if (findActiveOpeningStockEntry(tenantId).isPresent()) {
            throw new InvalidJournalEntryException(
                "Opening stock already posted for this tenant.");
        }

        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new InvalidJournalEntryException("Tenant not found"));

        Warehouse warehouse = warehouseRepo.findByTenantIdAndId(tenantId, req.warehouseId())
            .orElseThrow(() -> new InvalidJournalEntryException("Warehouse not found: " + req.warehouseId()));

        AccountingPeriod period = periodRepo.findActivePeriodForDate(tenantId, req.openingDate())
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open accounting period contains date " + req.openingDate()
                    + ". Please create a period first."));

        Long inventoryAssetId = requireAccount(tenantId, SystemAccountCode.INVENTORY_ASSET);
        Long capitalId = requireAccount(tenantId, SystemAccountCode.CAPITAL);

        // Validate unique item IDs in request
        Set<Long> seenItemIds = new HashSet<>();
        List<Item> items = new ArrayList<>();
        BigDecimal totalQuantity = BigDecimal.ZERO;
        BigDecimal totalValue = BigDecimal.ZERO;

        for (OpeningStockRequest.OpeningStockLine line : req.lines()) {
            if (!seenItemIds.add(line.itemId())) {
                throw new InvalidJournalEntryException("Duplicate item ID in lines: " + line.itemId());
            }

            Item item = itemRepo.findByTenantIdAndId(tenantId, line.itemId())
                .orElseThrow(() -> new InvalidJournalEntryException("Item not found: " + line.itemId()));
            if (!item.isTracksInventory()) {
                throw new InvalidJournalEntryException("Item " + item.getSku() + " does not track inventory");
            }
            items.add(item);

            BigDecimal lineTotal = line.quantity().multiply(line.unitCost()).setScale(4, RoundingMode.HALF_EVEN);
            totalQuantity = totalQuantity.add(line.quantity());
            totalValue = totalValue.add(lineTotal);
        }

        JournalEntry postedJe = null;
        if (totalValue.compareTo(BigDecimal.ZERO) > 0) {
            Currency currency = Currency.INR;
            String idempotencyKey = "OPENING_STOCK:" + tenantId + ":" + System.currentTimeMillis();

            JournalEntryBuilder builder = JournalEntryBuilder.create()
                .tenant(tenantId)
                .entryDate(req.openingDate())
                .period(period.getId())
                .type(EntryType.OPENING)
                .description("Opening stock for warehouse " + warehouse.getName() + " as of " + req.openingDate())
                .reference(REFERENCE_TYPE, 0L)
                .idempotencyKey(idempotencyKey)
                .createdBy(userId);

            builder.debit(inventoryAssetId, Money.of(totalValue, currency), "Opening inventory asset");
            builder.credit(capitalId, Money.of(totalValue, currency), "Opening stock equity");

            postedJe = postingService.post(builder.build(), userId);
        }

        Long refId = postedJe != null ? postedJe.getId() : 0L;

        // Process stock movements and stock balances
        for (int i = 0; i < req.lines().size(); i++) {
            OpeningStockRequest.OpeningStockLine line = req.lines().get(i);
            Item item = items.get(i);
            BigDecimal lineTotal = line.quantity().multiply(line.unitCost()).setScale(4, RoundingMode.HALF_EVEN);

            StockMovement mv = new StockMovement();
            mv.setTenantId(tenantId);
            mv.setItemId(item.getId());
            mv.setWarehouseId(warehouse.getId());
            mv.setMovementType(MovementType.OPENING);
            mv.setMovementDate(req.openingDate());
            mv.setQuantityIn(line.quantity());
            mv.setQuantityOut(BigDecimal.ZERO);
            mv.setUnitCost(line.unitCost());
            mv.setTotalValue(lineTotal);
            mv.setWacAfter(line.unitCost());
            mv.setReferenceType(REFERENCE_TYPE);
            mv.setReferenceId(refId);
            mv.setNotes("Opening stock initial count");
            mv.setCreatedBy(userId);
            movementRepo.save(mv);

            StockBalance balance = balanceRepo.findForUpdate(tenantId, item.getId(), warehouse.getId())
                .orElseGet(() -> {
                    StockBalance b = new StockBalance();
                    b.setTenantId(tenantId);
                    b.setItemId(item.getId());
                    b.setWarehouseId(warehouse.getId());
                    b.setQuantityOnHand(BigDecimal.ZERO);
                    b.setInventoryValue(BigDecimal.ZERO);
                    b.setWac(BigDecimal.ZERO);
                    return b;
                });

            BigDecimal newQty = balance.getQuantityOnHand().add(line.quantity());
            BigDecimal newValue = balance.getInventoryValue().add(lineTotal);
            BigDecimal newWac = newQty.signum() > 0
                ? newValue.divide(newQty, 4, RoundingMode.HALF_EVEN)
                : line.unitCost();

            balance.setQuantityOnHand(newQty);
            balance.setInventoryValue(newValue);
            balance.setWac(newWac);
            balance.setUpdatedAt(Instant.now());
            balanceRepo.save(balance);
        }

        if (tenant.getSetupStep() < 3) {
            tenant.setSetupStep(3);
            tenantRepo.save(tenant);
        }

        auditLog.record("POST_OPENING_STOCK", "JournalEntry", refId, "SUCCESS",
            Map.of("itemCount", req.lines().size(), "totalValue", totalValue), 0L);

        log.info("Posted opening stock for tenant {}: {} items, total value {}",
            tenantId, req.lines().size(), totalValue);

        return new OpeningStockResponse(
            true,
            postedJe != null ? postedJe.getId() : null,
            postedJe != null ? postedJe.getEntryNumber() : null,
            req.openingDate(),
            warehouse.getId(),
            req.lines().size(),
            totalQuantity,
            totalValue
        );
    }

    private Long requireAccount(Long tenantId, String code) {
        return accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .map(ChartOfAccount::getId)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account not found: " + code + " for tenant " + tenantId));
    }
}
