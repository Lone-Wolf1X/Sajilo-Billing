package com.saisa.financial.application.listener;

import com.saisa.billing.domain.event.PaymentPostedEvent;
import com.saisa.billing.domain.payment.PartyType;
import com.saisa.billing.domain.payment.PaymentMethod;
import com.saisa.billing.infrastructure.persistence.BankAccountRepository;
import com.saisa.billing.infrastructure.persistence.PaymentRepository;
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
public class PaymentPostingListener {

    private static final Logger log = LoggerFactory.getLogger(PaymentPostingListener.class);

    private final JournalPostingService postingService;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;
    private final JournalEntryRepository journalRepo;
    private final BankAccountRepository bankRepo;
    private final PaymentRepository paymentRepo;

    public PaymentPostingListener(
            JournalPostingService postingService,
            ChartOfAccountRepository accountRepo,
            AccountingPeriodRepository periodRepo,
            JournalEntryRepository journalRepo,
            BankAccountRepository bankRepo,
            PaymentRepository paymentRepo) {
        this.postingService = postingService;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
        this.journalRepo = journalRepo;
        this.bankRepo = bankRepo;
        this.paymentRepo = paymentRepo;
    }

    @EventListener
    public void onPaymentPosted(PaymentPostedEvent event) {
        log.info("Posting payment journal entry for payment {} (tenant {})",
            event.paymentNumber(), event.tenantId());

        Long tenantId = event.tenantId();

        // Idempotency check
        if (journalRepo.findByTenantIdAndReferenceTypeAndReferenceId(
                tenantId, "PAYMENT", event.paymentId()).isPresent()) {
            log.info("Journal entry already exists for payment {} - skipping", event.paymentNumber());
            return;
        }

        Long cashBankGlId;
        if (event.paymentMethod() == PaymentMethod.CASH) {
            cashBankGlId = requireAccount(tenantId, SystemAccountCode.CASH);
        } else {
            cashBankGlId = bankRepo.findById(event.bankAccountId())
                .orElseThrow(() -> new InvalidJournalEntryException("Bank account not found"))
                .getGlAccountId();
        }

        Long periodId = requirePeriod(tenantId, event.paymentDate());
        Currency currency = Currency.valueOf(event.currency());

        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(event.paymentDate())
            .period(periodId)
            .type(event.partyType() == PartyType.CUSTOMER ? EntryType.RECEIPT : EntryType.PAYMENT)
            .description(event.paymentNumber()
                + (event.referenceNo() != null ? " (Ref: " + event.referenceNo() + ")" : ""))
            .reference("PAYMENT", event.paymentId())
            .idempotencyKey("PAYMENT:" + event.paymentNumber())
            .createdBy(event.postedBy());

        Money amt = Money.of(event.amount(), currency);

        if (event.partyType() == PartyType.CUSTOMER) {
            // Money in: Cash/Bank Dr, AR Cr
            Long arId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_RECEIVABLE);
            builder.debit(cashBankGlId, amt, "Cash/bank received");
            builder.credit(arId, amt, "AR reduced");
        } else {
            // Money out: AP Dr, Cash/Bank Cr
            Long apId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_PAYABLE);
            builder.debit(apId, amt, "AP reduced");
            builder.credit(cashBankGlId, amt, "Cash/bank paid");
        }

        JournalEntry posted = postingService.post(builder.build(), event.postedBy());
        log.info("Payment {} posted as journal entry id={}",
            event.paymentNumber(), posted.getId());

        paymentRepo.findById(event.paymentId()).ifPresent(p -> {
            p.setJournalEntryId(posted.getId());
            paymentRepo.save(p);
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

