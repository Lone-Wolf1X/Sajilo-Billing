package com.saisa.billing.api.payment;

import com.saisa.billing.application.payment.PaymentPostingService;
import com.saisa.billing.domain.exception.InvalidPaymentException;
import com.saisa.billing.domain.payment.Payment;
import com.saisa.billing.domain.payment.PaymentAllocation;
import com.saisa.billing.infrastructure.persistence.PaymentRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/payments")
public class PaymentController {

    private final PaymentPostingService postingService;
    private final PaymentRepository paymentRepo;

    public PaymentController(PaymentPostingService postingService,
                             PaymentRepository paymentRepo) {
        this.postingService = postingService;
        this.paymentRepo = paymentRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<PaymentResponse> create(@Valid @RequestBody CreatePaymentRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (req.idempotencyKey() != null) {
            var existing = paymentRepo.findByTenantIdAndIdempotencyKey(tenantId, req.idempotencyKey());
            if (existing.isPresent()) {
                Payment p = existing.get();
                return ResponseEntity.ok(PaymentResponse.from(p, mapAllocs(p)));
            }
        }

        BigDecimal amount = new BigDecimal(req.amount());
        if (amount.signum() <= 0) {
            throw new InvalidPaymentException("Payment amount must be > 0");
        }

        Payment p = new Payment();
        p.setTenantId(tenantId);
        p.setPaymentNumber(req.paymentNumber());
        p.setPaymentDate(req.paymentDate());
        p.setAmount(amount);
        p.setCurrency("INR");
        p.setPartyType(req.partyType());
        p.setPartyId(req.partyId());
        p.setPaymentMethod(req.paymentMethod());
        p.setBankAccountId(req.bankAccountId());
        p.setReferenceNo(req.referenceNo());
        p.setNotes(req.notes());
        p.setIdempotencyKey(req.idempotencyKey());
        p.setCreatedBy(userId);

        if (req.allocations() != null) {
            for (var a : req.allocations()) {
                PaymentAllocation alloc = new PaymentAllocation();
                alloc.setInvoiceType(a.invoiceType().toUpperCase());
                alloc.setInvoiceId(a.invoiceId());
                alloc.setAllocatedAmount(new BigDecimal(a.amount()));
                p.addAllocation(alloc);
            }
        }

        Payment posted = postingService.post(p, userId);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(PaymentResponse.from(posted, mapAllocs(posted)));
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public PaymentResponse get(@PathVariable Long id) {
        Payment p = paymentRepo.findByIdWithAllocations(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Payment not found"));
        if (!p.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Payment not found");
        }
        return PaymentResponse.from(p, mapAllocs(p));
    }

    private List<PaymentResponse.Allocation> mapAllocs(Payment p) {
        List<PaymentResponse.Allocation> list = new ArrayList<>();
        if (p.getAllocations() != null) {
            for (PaymentAllocation a : p.getAllocations()) {
                list.add(new PaymentResponse.Allocation(
                    a.getInvoiceType(), a.getInvoiceId(), a.getAllocatedAmount()));
            }
        }
        return list;
    }
}
