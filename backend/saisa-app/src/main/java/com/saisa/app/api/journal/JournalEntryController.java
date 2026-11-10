package com.saisa.app.api.journal;

import com.saisa.app.api.common.AuthenticatedUser;
import com.saisa.app.api.common.TenantGuard;
import com.saisa.app.metrics.BusinessMetrics;
import com.saisa.common.audit.Auditable;
import com.saisa.financial.application.journal.JournalEntryQueryService;
import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.application.reversal.ReversalService;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/journal-entries")
@PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT', 'VIEWER')")
public class JournalEntryController {

    private final JournalEntryRepository journalRepo;
    private final JournalPostingService postingService;
    private final ReversalService reversalService;
    private final AccountingPeriodRepository periodRepo;
    private final ChartOfAccountRepository accountRepo;
    private final BusinessMetrics metrics;
    private final JournalEntryQueryService queryService;

    public JournalEntryController(JournalEntryRepository journalRepo,
                                  JournalPostingService postingService,
                                  ReversalService reversalService,
                                  AccountingPeriodRepository periodRepo,
                                  ChartOfAccountRepository accountRepo,
                                  BusinessMetrics metrics,
                                  JournalEntryQueryService queryService) {
        this.journalRepo = journalRepo;
        this.postingService = postingService;
        this.reversalService = reversalService;
        this.periodRepo = periodRepo;
        this.accountRepo = accountRepo;
        this.metrics = metrics;
        this.queryService = queryService;
    }

    @GetMapping
    public List<JournalEntryResponse> list(
            @RequestParam(required = false) LocalDate from,
            @RequestParam(required = false) LocalDate to,
            @RequestParam(required = false) EntryStatus status,
            @RequestParam(defaultValue = "50") int limit) {
        Long tenantId = AuthenticatedUser.tenantId();
        List<JournalEntry> entries = queryService.list(tenantId, from, to, status, limit);
        return entries.stream()
            .map(e -> JournalEntryResponse.from(e, List.of()))
            .toList();
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public JournalEntryResponse get(@PathVariable Long id) {
        JournalEntry e = journalRepo.findByIdWithLines(id)
            .orElseThrow(() -> new InvalidJournalEntryException("Entry not found: " + id));
        TenantGuard.ensureOwned(e.getTenantId());
        return JournalEntryResponse.from(e, e.getLines());
    }

    /**
     * Create a DRAFT entry. Does not post.
     * To post: POST /api/v1/journal-entries/{id}/post.
     */
    @PostMapping
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<JournalEntryResponse> create(
            @Valid @RequestBody CreateJournalEntryRequest req) {

        Long tenantId = AuthenticatedUser.tenantId();
        Long userId = AuthenticatedUser.userId();

        // CRITICAL: verify period belongs to current tenant.
        AccountingPeriod period = periodRepo.findById(req.periodId())
            .orElseThrow(() -> new InvalidJournalEntryException(
                "Period not found: " + req.periodId()));
        TenantGuard.ensureOwned(period.getTenantId());

        // CRITICAL: verify every account belongs to current tenant.
        for (var l : req.lines()) {
            ChartOfAccount acc = accountRepo.findById(l.accountId())
                .orElseThrow(() -> new InvalidJournalEntryException(
                    "Account not found: " + l.accountId()));
            TenantGuard.ensureOwned(acc.getTenantId());
        }

        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(req.entryDate())
            .period(req.periodId())
            .type(req.entryType())
            .description(req.description())
            .idempotencyKey(req.idempotencyKey())
            .createdBy(userId);

        if (req.referenceType() != null) {
            builder.reference(req.referenceType(), req.referenceId());
        }

        for (var l : req.lines()) {
            Money amount = Money.of(new BigDecimal(l.amount()), Currency.INR);
            if ("DEBIT".equalsIgnoreCase(l.side())) {
                builder.debit(l.accountId(), amount, l.description());
            } else if ("CREDIT".equalsIgnoreCase(l.side())) {
                builder.credit(l.accountId(), amount, l.description());
            } else {
                throw new InvalidJournalEntryException("Invalid side: " + l.side());
            }
        }

        JournalEntry draft = builder.build();
        JournalEntry saved = journalRepo.save(draft);

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(JournalEntryResponse.from(saved, saved.getLines()));
    }

    @PostMapping("/{id}/post")
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT')")
    @Auditable(action = "JOURNAL_POSTED", entityType = "JournalEntry")
    public JournalEntryResponse post(@PathVariable Long id) {
        JournalEntry draft = journalRepo.findByIdWithLines(id)
            .orElseThrow(() -> new InvalidJournalEntryException("Entry not found: " + id));
        TenantGuard.ensureOwned(draft.getTenantId());

        if (!draft.isDraft()) {
            throw new InvalidJournalEntryException(
                "Only DRAFT entries can be posted. Current status: " + draft.getStatus());
        }

        JournalEntry posted = postingService.post(draft, AuthenticatedUser.userId());
        if (metrics != null) {
            metrics.journalEntryPosted();
        }
        return JournalEntryResponse.from(posted, posted.getLines());
    }

    public record ReverseRequest(LocalDate reversalDate, String reason) {}

    @PostMapping("/{id}/reverse")
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT')")
    @Auditable(action = "JOURNAL_REVERSED", entityType = "JournalEntry")
    public JournalEntryResponse reverse(@PathVariable Long id,
                                        @RequestBody ReverseRequest req) {
        JournalEntry original = journalRepo.findById(id)
            .orElseThrow(() -> new InvalidJournalEntryException("Entry not found: " + id));
        TenantGuard.ensureOwned(original.getTenantId());

        JournalEntry reversal = reversalService.reverse(
            id,
            req.reversalDate() != null ? req.reversalDate() : LocalDate.now(),
            req.reason() != null ? req.reason() : "No reason provided",
            AuthenticatedUser.userId());

        return JournalEntryResponse.from(reversal, reversal.getLines());
    }
}
