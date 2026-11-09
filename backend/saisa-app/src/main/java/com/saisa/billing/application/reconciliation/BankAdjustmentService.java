package com.saisa.billing.application.reconciliation;

import com.saisa.billing.domain.payment.BankAccount;
import com.saisa.billing.domain.reconciliation.AdjustmentType;
import com.saisa.billing.domain.reconciliation.BankAdjustment;
import com.saisa.billing.infrastructure.persistence.BankAccountRepository;
import com.saisa.billing.infrastructure.persistence.BankAdjustmentRepository;
import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BankAdjustmentService {

    private static final Logger log = LoggerFactory.getLogger(BankAdjustmentService.class);

    private final BankAdjustmentRepository adjustmentRepo;
    private final BankAccountRepository bankRepo;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;
    private final JournalPostingService postingService;

    public BankAdjustmentService(
            BankAdjustmentRepository adjustmentRepo,
            BankAccountRepository bankRepo,
            ChartOfAccountRepository accountRepo,
            AccountingPeriodRepository periodRepo,
            JournalPostingService postingService) {
        this.adjustmentRepo = adjustmentRepo;
        this.bankRepo = bankRepo;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
        this.postingService = postingService;
    }

    @Transactional
    public BankAdjustment post(BankAdjustment draft, Long userId) {
        Long tenantId = draft.getTenantId();

        if (draft.getIdempotencyKey() != null) {
            var existing = adjustmentRepo.findByTenantIdAndIdempotencyKey(
                tenantId, draft.getIdempotencyKey());
            if (existing.isPresent()) return existing.get();
        }

        BankAccount bank = bankRepo.findById(draft.getBankAccountId())
            .orElseThrow(() -> new InvalidJournalEntryException("Bank account not found"));
        if (!bank.getTenantId().equals(tenantId)) {
            throw new InvalidJournalEntryException("Bank account not found");
        }

        Long periodId = requirePeriod(tenantId, draft.getAdjustmentDate());
        Currency currency = Currency.INR;
        Money amt = Money.of(draft.getAmount(), currency);

        JournalEntryBuilder b = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(draft.getAdjustmentDate())
            .period(periodId)
            .type(EntryType.ADJUSTMENT)
            .description("Bank adjustment: " + (draft.getDescription() != null ? draft.getDescription() : draft.getAdjustmentType().name()))
            .reference("BANK_ADJUSTMENT", draft.getId() != null ? draft.getId() : 0L)
            .idempotencyKey(draft.getIdempotencyKey() != null ? "BANK_ADJ:" + draft.getIdempotencyKey() : null)
            .createdBy(userId);

        Long bankGlId = bank.getGlAccountId();

        switch (draft.getAdjustmentType()) {
            case BANK_CHARGE -> {
                // Bank charges reduced our bank balance
                Long bankChargesId = requireAccount(tenantId, "BANK_CHARGES");
                b.debit(bankChargesId, amt, "Bank charges");
                b.credit(bankGlId, amt, "Bank balance reduced");
            }
            case INTEREST_CREDIT -> {
                Long interestId = requireAccount(tenantId, "INTEREST_INCOME");
                b.debit(bankGlId, amt, "Bank balance increased");
                b.credit(interestId, amt, "Interest earned");
            }
            case CORRECTION_IN -> {
                // Money actually came in, we missed it
                Long suspenseId = requireAccount(tenantId, "SUSPENSE");
                b.debit(bankGlId, amt, "Correction - inflow");
                b.credit(suspenseId, amt, "Suspense until identified");
            }
            case CORRECTION_OUT -> {
                Long suspenseId = requireAccount(tenantId, "SUSPENSE");
                b.debit(suspenseId, amt, "Suspense until identified");
                b.credit(bankGlId, amt, "Correction - outflow");
            }
        }

        JournalEntry posted = postingService.post(b.build(), userId);
        draft.setJournalEntryId(posted.getId());
        draft.setCreatedBy(userId);

        BankAdjustment saved = adjustmentRepo.save(draft);
        log.info("Posted bank adjustment {} for bank {} (type: {})",
            saved.getId(), bank.getId(), saved.getAdjustmentType());
        return saved;
    }

    private Long requireAccount(Long tenantId, String code) {
        ChartOfAccount a = accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account '" + code + "' missing"));
        return a.getId();
    }

    private Long requirePeriod(Long tenantId, java.time.LocalDate date) {
        AccountingPeriod p = periodRepo.findActivePeriodForDate(tenantId, date)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open period for date " + date));
        return p.getId();
    }
}

