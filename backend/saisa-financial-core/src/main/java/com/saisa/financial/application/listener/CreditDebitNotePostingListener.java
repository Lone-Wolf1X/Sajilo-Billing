package com.saisa.financial.application.listener;

import com.saisa.billing.domain.event.CreditNotePostedEvent;
import com.saisa.billing.domain.event.DebitNotePostedEvent;
import com.saisa.billing.infrastructure.persistence.CreditNoteRepository;
import com.saisa.billing.infrastructure.persistence.DebitNoteRepository;
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

@Component
public class CreditDebitNotePostingListener {

    private static final Logger log = LoggerFactory.getLogger(CreditDebitNotePostingListener.class);

    private final JournalPostingService postingService;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;
    private final JournalEntryRepository journalRepo;
    private final CreditNoteRepository creditRepo;
    private final DebitNoteRepository debitRepo;

    public CreditDebitNotePostingListener(
            JournalPostingService postingService,
            ChartOfAccountRepository accountRepo,
            AccountingPeriodRepository periodRepo,
            JournalEntryRepository journalRepo,
            CreditNoteRepository creditRepo,
            DebitNoteRepository debitRepo) {
        this.postingService = postingService;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
        this.journalRepo = journalRepo;
        this.creditRepo = creditRepo;
        this.debitRepo = debitRepo;
    }

    /**
     * Credit Note (Sales Return):
     *   Sales Return Dr (subtotal)
     *   GST Output Dr (tax)
     *     AR Cr (total)
     */
    @EventListener
    public void onCreditNotePosted(CreditNotePostedEvent e) {
        Long tenantId = e.tenantId();

        if (journalRepo.findByTenantIdAndReferenceTypeAndReferenceId(
                tenantId, "CREDIT_NOTE", e.creditNoteId()).isPresent()) {
            log.info("Credit note {} already posted - skipping", e.creditNoteNumber());
            return;
        }

        Long salesReturnId = requireAccount(tenantId, SystemAccountCode.SALES_RETURN);
        Long gstOutId = requireAccount(tenantId, SystemAccountCode.GST_OUTPUT_PAYABLE);
        Long arId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_RECEIVABLE);
        Long periodId = requirePeriod(tenantId, e.creditNoteDate());
        Currency currency = Currency.valueOf(e.currency());

        JournalEntryBuilder b = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(e.creditNoteDate())
            .period(periodId)
            .type(EntryType.SALES)
            .description("Credit note " + e.creditNoteNumber())
            .reference("CREDIT_NOTE", e.creditNoteId())
            .idempotencyKey("CREDIT_NOTE:" + e.creditNoteId())
            .createdBy(e.postedBy());

        if (e.subtotal().signum() > 0) {
            b.debit(salesReturnId, Money.of(e.subtotal(), currency), "Sales return");
        }
        if (e.taxAmount().signum() > 0) {
            b.debit(gstOutId, Money.of(e.taxAmount(), currency), "GST output reversed");
        }
        b.credit(arId, Money.of(e.totalAmount(), currency), "AR reduced");

        JournalEntry posted = postingService.post(b.build(), e.postedBy());
        log.info("Credit note {} posted as journal entry {}",
            e.creditNoteNumber(), posted.getId());

        creditRepo.findById(e.creditNoteId()).ifPresent(cn -> {
            cn.setJournalEntryId(posted.getId());
            creditRepo.save(cn);
        });
    }

    /**
     * Debit Note (Purchase Return):
     *   AP Dr (total)
     *     Purchase Return Cr (subtotal)
     *     GST Input Cr (tax)
     */
    @EventListener
    public void onDebitNotePosted(DebitNotePostedEvent e) {
        Long tenantId = e.tenantId();

        if (journalRepo.findByTenantIdAndReferenceTypeAndReferenceId(
                tenantId, "DEBIT_NOTE", e.debitNoteId()).isPresent()) {
            log.info("Debit note {} already posted - skipping", e.debitNoteNumber());
            return;
        }

        Long purchaseReturnId = requireAccount(tenantId, SystemAccountCode.PURCHASE_RETURN);
        Long gstInId = requireAccount(tenantId, SystemAccountCode.GST_INPUT_CREDIT);
        Long apId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_PAYABLE);
        Long periodId = requirePeriod(tenantId, e.debitNoteDate());
        Currency currency = Currency.valueOf(e.currency());

        JournalEntryBuilder b = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(e.debitNoteDate())
            .period(periodId)
            .type(EntryType.PURCHASE)
            .description("Debit note " + e.debitNoteNumber())
            .reference("DEBIT_NOTE", e.debitNoteId())
            .idempotencyKey("DEBIT_NOTE:" + e.debitNoteId())
            .createdBy(e.postedBy());

        b.debit(apId, Money.of(e.totalAmount(), currency), "AP reduced");

        if (e.subtotal().signum() > 0) {
            b.credit(purchaseReturnId, Money.of(e.subtotal(), currency), "Purchase return");
        }
        if (e.taxAmount().signum() > 0) {
            b.credit(gstInId, Money.of(e.taxAmount(), currency), "GST input reversed");
        }

        JournalEntry posted = postingService.post(b.build(), e.postedBy());
        log.info("Debit note {} posted as journal entry {}",
            e.debitNoteNumber(), posted.getId());

        debitRepo.findById(e.debitNoteId()).ifPresent(dn -> {
            dn.setJournalEntryId(posted.getId());
            debitRepo.save(dn);
        });
    }

    private Long requireAccount(Long tenantId, String code) {
        ChartOfAccount a = accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account '" + code + "' missing"));
        return a.getId();
    }

    private Long requirePeriod(Long tenantId, LocalDate date) {
        AccountingPeriod p = periodRepo.findActivePeriodForDate(tenantId, date)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open period for date " + date));
        return p.getId();
    }
}

