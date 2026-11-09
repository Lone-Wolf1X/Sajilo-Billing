package com.saisa.billing.api.reconciliation;

import com.saisa.billing.application.reconciliation.BankReconciliationService;
import com.saisa.billing.application.reconciliation.ReconciliationReportService;
import com.saisa.billing.domain.exception.InvalidBankReconciliationException;
import com.saisa.billing.domain.reconciliation.BankStatementLine;
import com.saisa.billing.infrastructure.persistence.BankStatementLineRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/bank-reconciliation")
public class BankReconciliationController {

    private final BankStatementLineRepository lineRepo;
    private final BankReconciliationService reconService;
    private final ReconciliationReportService reportService;

    public BankReconciliationController(
            BankStatementLineRepository lineRepo,
            BankReconciliationService reconService,
            ReconciliationReportService reportService) {
        this.lineRepo = lineRepo;
        this.reconService = reconService;
        this.reportService = reportService;
    }

    @GetMapping("/lines")
    public List<BankStatementLine> listLines(@RequestParam Long bankAccountId) {
        return lineRepo.findByTenantIdAndBankAccountIdOrderByStatementDate(
            TenantContext.getCurrentTenantId(), bankAccountId);
    }

    @PostMapping("/lines")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<BankStatementLine> addLine(
            @Valid @RequestBody CreateStatementLineRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        BigDecimal debit = req.debitAmount() != null && !req.debitAmount().isBlank()
            ? new BigDecimal(req.debitAmount()) : BigDecimal.ZERO;
        BigDecimal credit = req.creditAmount() != null && !req.creditAmount().isBlank()
            ? new BigDecimal(req.creditAmount()) : BigDecimal.ZERO;

        if ((debit.signum() == 0 && credit.signum() == 0) || (debit.signum() > 0 && credit.signum() > 0)) {
            throw new InvalidBankReconciliationException(
                "Statement line must have either debit > 0 or credit > 0, not both or neither");
        }

        BankStatementLine line = new BankStatementLine();
        line.setTenantId(tenantId);
        line.setBankAccountId(req.bankAccountId());
        line.setStatementDate(req.statementDate());
        line.setDescription(req.description());
        line.setReferenceNo(req.referenceNo());
        line.setDebitAmount(debit);
        line.setCreditAmount(credit);
        line.setRunningBalance(req.runningBalance() != null && !req.runningBalance().isBlank()
            ? new BigDecimal(req.runningBalance()) : null);
        line.setCreatedBy(userId);

        return ResponseEntity.status(HttpStatus.CREATED).body(lineRepo.save(line));
    }

    @PostMapping("/auto-match")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public Map<String, Object> autoMatch(@RequestParam Long bankAccountId) {
        int matched = reconService.autoMatch(
            TenantContext.getCurrentTenantId(), bankAccountId);
        return Map.of("matched", matched);
    }

    public record ManualMatchRequest(Long statementLineId, Long paymentId) {}

    @PostMapping("/match")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public BankStatementLine manualMatch(@RequestBody ManualMatchRequest req) {
        return reconService.manualMatch(
            TenantContext.getCurrentTenantId(),
            req.statementLineId(), req.paymentId(),
            TenantContext.getCurrentUserId());
    }

    @PostMapping("/lines/{id}/unmatch")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public BankStatementLine unmatch(@PathVariable Long id) {
        return reconService.unmatch(TenantContext.getCurrentTenantId(), id);
    }

    @PostMapping("/lines/{id}/ignore")
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public BankStatementLine ignore(@PathVariable Long id) {
        return reconService.ignore(TenantContext.getCurrentTenantId(), id,
            TenantContext.getCurrentUserId());
    }

    @GetMapping("/summary")
    @Transactional(readOnly = true)
    public ReconciliationReportService.ReconciliationSummary summary(
            @RequestParam Long bankAccountId,
            @RequestParam(required = false) LocalDate asOf) {
        return reportService.generate(
            TenantContext.getCurrentTenantId(), bankAccountId,
            asOf != null ? asOf : LocalDate.now());
    }
}
