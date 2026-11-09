package com.saisa.billing.api.reconciliation;

import com.saisa.billing.application.reconciliation.BankAdjustmentService;
import com.saisa.billing.domain.reconciliation.AdjustmentType;
import com.saisa.billing.domain.reconciliation.BankAdjustment;
import com.saisa.common.tenant.TenantContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/bank-adjustments")
public class BankAdjustmentController {

    public record CreateAdjustmentRequest(
        Long bankAccountId, LocalDate adjustmentDate,
        AdjustmentType type, String amount, String description,
        String idempotencyKey) {}

    private final BankAdjustmentService service;

    public BankAdjustmentController(BankAdjustmentService service) {
        this.service = service;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<BankAdjustment> create(@RequestBody CreateAdjustmentRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        BankAdjustment adj = new BankAdjustment();
        adj.setTenantId(tenantId);
        adj.setBankAccountId(req.bankAccountId());
        adj.setAdjustmentDate(req.adjustmentDate());
        adj.setAdjustmentType(req.type());
        adj.setAmount(new BigDecimal(req.amount()));
        adj.setDescription(req.description());
        adj.setIdempotencyKey(req.idempotencyKey());

        BankAdjustment saved = service.post(adj, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
}
