package com.saisa.inventory.event;

import com.saisa.billing.domain.event.PurchaseInvoicePostedEvent;
import com.saisa.billing.domain.event.SalesInvoicePostedEvent;
import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.domain.account.ChartOfAccount;
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
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import com.saisa.inventory.application.InventoryService;
import java.math.BigDecimal;
import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class InventoryPostingListener {

    private static final Logger log = LoggerFactory.getLogger(InventoryPostingListener.class);

    private final InventoryService inventoryService;
    private final JournalPostingService postingService;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;
    private final JournalEntryRepository journalRepo;

    public InventoryPostingListener(InventoryService inventoryService,
                                    JournalPostingService postingService,
                                    ChartOfAccountRepository accountRepo,
                                    AccountingPeriodRepository periodRepo,
                                    JournalEntryRepository journalRepo) {
        this.inventoryService = inventoryService;
        this.postingService = postingService;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
        this.journalRepo = journalRepo;
    }

    @EventListener
    public void onPurchaseInvoicePosted(PurchaseInvoicePostedEvent event) {
        if (event.lines() == null || event.lines().isEmpty()) {
            return;
        }

        log.info("Processing inventory movements for purchase invoice {}", event.invoiceNumber());
        for (var line : event.lines()) {
            if (line.itemId() != null) {
                inventoryService.receiveStock(
                    event.tenantId(),
                    event.warehouseId(),
                    line.itemId(),
                    line.quantity(),
                    line.unitPrice(),
                    event.invoiceDate(),
                    "PURCHASE_INVOICE",
                    event.invoiceId(),
                    "Purchase invoice " + event.invoiceNumber(),
                    event.postedBy()
                );
            }
        }
    }

    @EventListener
    public void onSalesInvoicePosted(SalesInvoicePostedEvent event) {
        if (event.lines() == null || event.lines().isEmpty()) {
            return;
        }

        log.info("Processing inventory movements for sales invoice {}", event.invoiceNumber());
        BigDecimal totalCogs = BigDecimal.ZERO;

        for (var line : event.lines()) {
            if (line.itemId() != null) {
                BigDecimal lineCogs = inventoryService.issueStock(
                    event.tenantId(),
                    event.warehouseId(),
                    line.itemId(),
                    line.quantity(),
                    event.invoiceDate(),
                    "SALES_INVOICE",
                    event.invoiceId(),
                    "Sales invoice " + event.invoiceNumber(),
                    event.postedBy()
                );
                totalCogs = totalCogs.add(lineCogs);
            }
        }

        // Post automated COGS journal entry if total COGS > 0
        if (totalCogs.signum() > 0) {
            postCogsJournalEntry(event, totalCogs);
        }
    }

    private void postCogsJournalEntry(SalesInvoicePostedEvent event, BigDecimal cogsAmount) {
        Long tenantId = event.tenantId();

        // Idempotency check
        if (journalRepo.findByTenantIdAndReferenceTypeAndReferenceId(
                tenantId, "SALES_INVOICE_COGS", event.invoiceId()).isPresent()) {
            log.info("COGS journal entry already exists for sales invoice {} - skipping", event.invoiceNumber());
            return;
        }

        Long cogsAccountId = requireAccount(tenantId, SystemAccountCode.COGS);
        Long invAssetAccountId = requireAccount(tenantId, SystemAccountCode.INVENTORY_ASSET);
        Long periodId = requirePeriod(tenantId, event.invoiceDate());

        Currency currency = Currency.valueOf(event.currency());
        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(event.invoiceDate())
            .period(periodId)
            .type(EntryType.JOURNAL)
            .description("Cost of Goods Sold - " + event.invoiceNumber())
            .reference("SALES_INVOICE_COGS", event.invoiceId())
            .idempotencyKey("COGS_SALES_INVOICE:" + event.invoiceId());

        // COGS Dr
        builder.debit(cogsAccountId, Money.of(cogsAmount, currency),
            "COGS for invoice " + event.invoiceNumber());

        // INVENTORY_ASSET Cr
        builder.credit(invAssetAccountId, Money.of(cogsAmount, currency),
            "Inventory reduction for invoice " + event.invoiceNumber());

        JournalEntry posted = postingService.post(builder.build(), event.postedBy());
        log.info("Posted COGS journal entry id={} for sales invoice {}",
            posted.getId(), event.invoiceNumber());
    }

    private Long requireAccount(Long tenantId, String code) {
        ChartOfAccount acc = accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account '" + code + "' missing. Please seed system accounts for tenant " + tenantId));
        return acc.getId();
    }

    private Long requirePeriod(Long tenantId, LocalDate date) {
        AccountingPeriod p = periodRepo.findActivePeriodForDate(tenantId, date)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open accounting period contains date " + date));
        return p.getId();
    }
}

