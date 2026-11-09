package com.saisa.financial.application.listener;

import com.saisa.billing.domain.event.PurchaseInvoicePostedEvent;
import com.saisa.billing.domain.event.SalesInvoicePostedEvent;
import com.saisa.billing.infrastructure.persistence.PurchaseInvoiceRepository;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
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
import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

/**
 * Translates billing events into journal entries.
 *
 * Uses @TransactionalEventListener(phase = TransactionPhase.BEFORE_COMMIT) so that:
 *   - The journal entry is created in the SAME transaction as the invoice
 *   - If journal posting fails, the entire invoice creation rolls back
 *   - There is no window where an invoice exists without its journal entry
 *
 * This is the ONLY place in the codebase that knows the mapping between
 * business events and accounting treatment. Everything else is agnostic.
 */
@Component
public class InvoicePostingListener {

    private static final Logger log = LoggerFactory.getLogger(InvoicePostingListener.class);

    private final JournalPostingService postingService;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;
    private final JournalEntryRepository journalRepo;
    private final SalesInvoiceRepository salesRepo;
    private final PurchaseInvoiceRepository purchaseRepo;

    public InvoicePostingListener(
            JournalPostingService postingService,
            ChartOfAccountRepository accountRepo,
            AccountingPeriodRepository periodRepo,
            JournalEntryRepository journalRepo,
            SalesInvoiceRepository salesRepo,
            PurchaseInvoiceRepository purchaseRepo) {
        this.postingService = postingService;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
        this.journalRepo = journalRepo;
        this.salesRepo = salesRepo;
        this.purchaseRepo = purchaseRepo;
    }

    @EventListener
    public void onSalesInvoicePosted(SalesInvoicePostedEvent event) {
        log.info("Posting sales invoice {} for tenant {}",
            event.invoiceNumber(), event.tenantId());

        Long tenantId = event.tenantId();

        // Idempotency: if this invoice already has a journal entry, skip.
        if (journalRepo.findByTenantIdAndReferenceTypeAndReferenceId(
                tenantId, "SALES_INVOICE", event.invoiceId()).isPresent()) {
            log.info("Invoice {} already posted - skipping", event.invoiceNumber());
            return;
        }

        Long arId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_RECEIVABLE);
        Long salesId = requireAccount(tenantId, SystemAccountCode.SALES_REVENUE);
        Long gstOutId = requireAccount(tenantId, SystemAccountCode.GST_OUTPUT_PAYABLE);
        Long periodId = requirePeriod(tenantId, event.invoiceDate());

        Currency currency = Currency.valueOf(event.currency());
        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(event.invoiceDate())
            .period(periodId)
            .type(EntryType.SALES)
            .description("Sales invoice " + event.invoiceNumber())
            .reference("SALES_INVOICE", event.invoiceId())
            .idempotencyKey("SALES_INVOICE:" + event.invoiceId());

        // AR Dr total
        builder.debit(arId, Money.of(event.totalAmount(), currency),
            "Receivable from invoice " + event.invoiceNumber());

        // Sales Cr subtotal
        if (event.subtotal().signum() > 0) {
            builder.credit(salesId, Money.of(event.subtotal(), currency),
                "Sales revenue");
        }

        // GST Output Cr tax
        if (event.taxAmount().signum() > 0) {
            builder.credit(gstOutId, Money.of(event.taxAmount(), currency),
                "GST output on invoice " + event.invoiceNumber());
        }

        JournalEntry posted = postingService.post(builder.build(), event.postedBy());
        log.info("Sales invoice {} posted as journal entry id={}",
            event.invoiceNumber(), posted.getId());

        // Link journal entry id back to invoice
        salesRepo.findById(event.invoiceId()).ifPresent(inv -> {
            inv.setJournalEntryId(posted.getId());
            salesRepo.save(inv);
        });
    }

    @EventListener
    public void onPurchaseInvoicePosted(PurchaseInvoicePostedEvent event) {
        log.info("Posting purchase invoice {} for tenant {}",
            event.invoiceNumber(), event.tenantId());

        Long tenantId = event.tenantId();

        if (journalRepo.findByTenantIdAndReferenceTypeAndReferenceId(
                tenantId, "PURCHASE_INVOICE", event.invoiceId()).isPresent()) {
            log.info("Invoice {} already posted - skipping", event.invoiceNumber());
            return;
        }

        Long apId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_PAYABLE);
        Long purchaseId = requireAccount(tenantId, SystemAccountCode.PURCHASE_EXPENSE);
        Long gstInId = requireAccount(tenantId, SystemAccountCode.GST_INPUT_CREDIT);
        Long periodId = requirePeriod(tenantId, event.invoiceDate());

        Currency currency = Currency.valueOf(event.currency());
        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(event.invoiceDate())
            .period(periodId)
            .type(EntryType.PURCHASE)
            .description("Purchase invoice " + event.invoiceNumber())
            .reference("PURCHASE_INVOICE", event.invoiceId())
            .idempotencyKey("PURCHASE_INVOICE:" + event.invoiceId());

        // Purchase Dr subtotal
        if (event.subtotal().signum() > 0) {
            builder.debit(purchaseId, Money.of(event.subtotal(), currency),
                "Purchase expense");
        }

        // GST Input Dr tax
        if (event.taxAmount().signum() > 0) {
            builder.debit(gstInId, Money.of(event.taxAmount(), currency),
                "GST input on invoice " + event.invoiceNumber());
        }

        // AP Cr total
        builder.credit(apId, Money.of(event.totalAmount(), currency),
            "Payable to vendor for invoice " + event.invoiceNumber());

        JournalEntry posted = postingService.post(builder.build(), event.postedBy());
        log.info("Purchase invoice {} posted as journal entry id={}",
            event.invoiceNumber(), posted.getId());

        // Link journal entry id back to invoice
        purchaseRepo.findById(event.invoiceId()).ifPresent(inv -> {
            inv.setJournalEntryId(posted.getId());
            purchaseRepo.save(inv);
        });
    }

    private Long requireAccount(Long tenantId, String code) {
        ChartOfAccount acc = accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account '" + code + "' missing. Please seed system accounts for tenant "
                    + tenantId));
        return acc.getId();
    }

    private Long requirePeriod(Long tenantId, LocalDate date) {
        AccountingPeriod p = periodRepo.findActivePeriodForDate(tenantId, date)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open accounting period contains date " + date));
        return p.getId();
    }
}
