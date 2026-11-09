package com.saisa.app.setup;

import com.saisa.common.audit.AuditLogService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.tenant.dto.OpeningBalanceRequest;
import com.saisa.common.tenant.dto.OpeningBalanceResponse;
import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.application.reversal.ReversalService;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.account.SystemAccountCode;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OpeningBalanceService {

    private static final Logger log = LoggerFactory.getLogger(OpeningBalanceService.class);
    private static final String REFERENCE_TYPE = "OPENING_BALANCE";

    private final TenantRepository tenantRepo;
    private final JournalEntryRepository journalRepo;
    private final ChartOfAccountRepository accountRepo;
    private final AccountingPeriodRepository periodRepo;
    private final JournalPostingService postingService;
    private final ReversalService reversalService;
    private final AuditLogService auditLog;

    public OpeningBalanceService(
            TenantRepository tenantRepo,
            JournalEntryRepository journalRepo,
            ChartOfAccountRepository accountRepo,
            AccountingPeriodRepository periodRepo,
            JournalPostingService postingService,
            ReversalService reversalService,
            AuditLogService auditLog) {
        this.tenantRepo = tenantRepo;
        this.journalRepo = journalRepo;
        this.accountRepo = accountRepo;
        this.periodRepo = periodRepo;
        this.postingService = postingService;
        this.reversalService = reversalService;
        this.auditLog = auditLog;
    }

    @Transactional(readOnly = true)
    public Optional<JournalEntry> findActiveOpeningEntry(Long tenantId) {
        return journalRepo.findByTenantIdAndReferenceWithLines(tenantId, REFERENCE_TYPE, 0L)
            .stream()
            .filter(j -> j.getEntryType() == EntryType.OPENING && j.getStatus() == EntryStatus.POSTED)
            .findFirst();
    }

    @Transactional(readOnly = true)
    public OpeningBalanceResponse getCurrent(Long tenantId) {
        return findActiveOpeningEntry(tenantId)
            .map(this::toResponse)
            .orElse(new OpeningBalanceResponse(
                false, null, null, null,
                BigDecimal.ZERO, BigDecimal.ZERO,
                BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, true));
    }

    @Transactional
    public OpeningBalanceResponse post(Long tenantId, OpeningBalanceRequest req, Long userId) {
        // Idempotency: block re-post while active
        if (findActiveOpeningEntry(tenantId).isPresent()) {
            throw new InvalidJournalEntryException(
                "Opening balance already posted. Reset it first to modify.");
        }

        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new InvalidJournalEntryException("Tenant not found"));

        // Validate period exists for opening date
        AccountingPeriod period = periodRepo.findActivePeriodForDate(tenantId, req.openingDate())
            .orElseThrow(() -> new InvalidJournalEntryException(
                "No open accounting period contains date " + req.openingDate()
                    + ". Please create a period first."));

        // Resolve accounts
        Long cashId = requireAccount(tenantId, SystemAccountCode.CASH);
        Long bankId = requireAccount(tenantId, SystemAccountCode.BANK);
        Long arId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_RECEIVABLE);
        Long fixedAssetsId = requireAccount(tenantId, SystemAccountCode.FIXED_ASSETS);
        Long investmentsId = requireAccount(tenantId, SystemAccountCode.INVESTMENTS);
        Long otherAssetsId = requireAccount(tenantId, SystemAccountCode.OTHER_ASSETS);
        Long apId = requireAccount(tenantId, SystemAccountCode.ACCOUNTS_PAYABLE);
        Long loansId = requireAccount(tenantId, SystemAccountCode.BANK_LOANS);
        Long otherLiabId = requireAccount(tenantId, SystemAccountCode.OTHER_LIABILITIES);
        Long capitalId = requireAccount(tenantId, SystemAccountCode.CAPITAL);
        Long retainedEarningsId = requireAccount(tenantId, SystemAccountCode.RETAINED_EARNINGS);

        // Parse amounts
        BigDecimal cash = parse(req.cashInHand());
        BigDecimal bank = parse(req.bankBalance());
        BigDecimal ar = parse(req.accountsReceivable());
        BigDecimal fixedAssets = parse(req.fixedAssets());
        BigDecimal investments = parse(req.investments());
        BigDecimal otherAssets = parse(req.otherAssets());
        BigDecimal ap = parse(req.accountsPayable());
        BigDecimal loans = parse(req.bankLoans());
        BigDecimal otherLiab = parse(req.otherLiabilities());
        BigDecimal retainedEarnings = parse(req.retainedEarnings());

        BigDecimal totalAssets = cash.add(bank).add(ar)
            .add(fixedAssets).add(investments).add(otherAssets);
        BigDecimal totalLiabilities = ap.add(loans).add(otherLiab);
        BigDecimal autoCapital = totalAssets.subtract(totalLiabilities).subtract(retainedEarnings);

        BigDecimal capital = (req.capital() != null && !req.capital().isBlank())
            ? parse(req.capital())
            : autoCapital;

        BigDecimal totalEquity = capital.add(retainedEarnings);

        BigDecimal totalDebits = totalAssets;
        BigDecimal totalCredits = totalLiabilities.add(totalEquity);

        if (totalDebits.compareTo(totalCredits) != 0) {
            throw new InvalidJournalEntryException(
                "Opening balances do not balance. "
                + "Total Debits (Assets): " + totalDebits + ", "
                + "Total Credits (Liabilities + Equity): " + totalCredits
                + ". Difference: " + totalDebits.subtract(totalCredits));
        }

        if (totalDebits.signum() <= 0) {
            throw new InvalidJournalEntryException("Opening balances cannot all be zero");
        }

        // Build the entry
        Currency currency = Currency.INR;
        String idempotencyKey = "OPENING_BALANCE:" + tenantId + ":" + System.currentTimeMillis();

        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(req.openingDate())
            .period(period.getId())
            .type(EntryType.OPENING)
            .description("Opening balances as of " + req.openingDate()
                + " for FY " + tenant.getFiscalYearStartMonth() + "-based year")
            .reference(REFERENCE_TYPE, 0L)
            .idempotencyKey(idempotencyKey)
            .createdBy(userId);

        addDebitIfPositive(builder, cashId, cash, "Cash in hand", currency);
        addDebitIfPositive(builder, bankId, bank, "Bank balance", currency);
        addDebitIfPositive(builder, arId, ar, "Accounts receivable", currency);
        addDebitIfPositive(builder, fixedAssetsId, fixedAssets, "Fixed assets", currency);
        addDebitIfPositive(builder, investmentsId, investments, "Investments", currency);
        addDebitIfPositive(builder, otherAssetsId, otherAssets, "Other assets", currency);

        addCreditIfPositive(builder, apId, ap, "Accounts payable", currency);
        addCreditIfPositive(builder, loansId, loans, "Bank loans", currency);
        addCreditIfPositive(builder, otherLiabId, otherLiab, "Other liabilities", currency);
        addCreditIfPositive(builder, capitalId, capital, "Owner's capital", currency);
        addCreditIfPositive(builder, retainedEarningsId, retainedEarnings, "Retained earnings", currency);

        JournalEntry posted = postingService.post(builder.build(), userId);

        // Advance setup step
        if (tenant.getSetupStep() < 2) {
            tenant.setSetupStep(2);
            tenantRepo.save(tenant);
        }

        auditLog.record("POST_OPENING_BALANCES", "JournalEntry", posted.getId(), "SUCCESS",
            Map.of("totalAssets", totalAssets, "totalLiabilities", totalLiabilities, "totalEquity", totalEquity), 0L);

        log.info("Posted opening balance for tenant {} as journal entry {}",
            tenantId, posted.getId());

        return new OpeningBalanceResponse(
            true, posted.getId(), posted.getEntryNumber(), req.openingDate(),
            totalDebits, totalCredits, totalAssets, totalLiabilities, totalEquity, true);
    }

    @Transactional
    public void resetViaReversal(Long tenantId, Long userId, String reason) {
        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new InvalidJournalEntryException("Tenant not found"));
        if (tenant.isSetupCompleted()) {
            throw new InvalidJournalEntryException(
                "Cannot reset opening balances after setup is completed");
        }

        JournalEntry original = findActiveOpeningEntry(tenantId)
            .orElseThrow(() -> new InvalidJournalEntryException("No active opening balance to reset"));

        String actualReason = (reason != null && !reason.isBlank()) ? reason : "Reset opening balances";
        JournalEntry reversal = reversalService.reverse(original.getId(), LocalDate.now(), actualReason, userId);

        auditLog.record("RESET_OPENING_BALANCES", "JournalEntry", reversal.getId(), "SUCCESS",
            Map.of("originalEntryId", original.getId(), "reversalEntryId", reversal.getId(), "reason", actualReason), 0L);

        log.info("Reset opening balance via reversal {} for tenant {}",
            reversal.getId(), tenantId);
    }

    private OpeningBalanceResponse toResponse(JournalEntry entry) {
        BigDecimal totalDr = BigDecimal.ZERO;
        BigDecimal totalCr = BigDecimal.ZERO;
        if (entry.getLines() != null) {
            for (var line : entry.getLines()) {
                totalDr = totalDr.add(line.getDebitAmount() != null ? line.getDebitAmount() : BigDecimal.ZERO);
                totalCr = totalCr.add(line.getCreditAmount() != null ? line.getCreditAmount() : BigDecimal.ZERO);
            }
        }
        return new OpeningBalanceResponse(
            true, entry.getId(), entry.getEntryNumber(), entry.getEntryDate(),
            totalDr, totalCr, totalDr, totalCr.subtract(totalDr).max(BigDecimal.ZERO),
            BigDecimal.ZERO, totalDr.compareTo(totalCr) == 0);
    }

    private void addDebitIfPositive(JournalEntryBuilder b, Long accountId,
                                    BigDecimal amount, String desc, Currency currency) {
        if (amount.signum() > 0) {
            b.debit(accountId, Money.of(amount, currency), desc);
        }
    }

    private void addCreditIfPositive(JournalEntryBuilder b, Long accountId,
                                     BigDecimal amount, String desc, Currency currency) {
        if (amount.signum() > 0) {
            b.credit(accountId, Money.of(amount, currency), desc);
        }
    }

    private BigDecimal parse(String s) {
        if (s == null || s.isBlank()) return BigDecimal.ZERO;
        return new BigDecimal(s.replace(",", "").trim());
    }

    private Long requireAccount(Long tenantId, String code) {
        ChartOfAccount a = accountRepo.findByTenantIdAndAccountCode(tenantId, code)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "System account '" + code + "' missing for tenant " + tenantId));
        return a.getId();
    }
}
