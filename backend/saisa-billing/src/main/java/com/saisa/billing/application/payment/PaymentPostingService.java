package com.saisa.billing.application.payment;

import com.saisa.billing.domain.event.PaymentPostedEvent;
import com.saisa.billing.domain.exception.InvalidPaymentException;
import com.saisa.billing.domain.invoice.PurchaseInvoice;
import com.saisa.billing.domain.invoice.SalesInvoice;
import com.saisa.billing.domain.payment.PartyType;
import com.saisa.billing.domain.payment.Payment;
import com.saisa.billing.domain.payment.PaymentAllocation;
import com.saisa.billing.domain.payment.PaymentMethod;
import com.saisa.billing.domain.payment.PaymentStatus;
import com.saisa.billing.infrastructure.persistence.BankAccountRepository;
import com.saisa.billing.infrastructure.persistence.PaymentRepository;
import com.saisa.billing.infrastructure.persistence.PurchaseInvoiceRepository;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
import java.math.BigDecimal;
import java.time.Instant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PaymentPostingService {

    private static final Logger log = LoggerFactory.getLogger(PaymentPostingService.class);

    private final PaymentRepository paymentRepo;
    private final SalesInvoiceRepository salesRepo;
    private final PurchaseInvoiceRepository purchaseRepo;
    private final BankAccountRepository bankRepo;
    private final ApplicationEventPublisher publisher;

    public PaymentPostingService(PaymentRepository paymentRepo,
                                 SalesInvoiceRepository salesRepo,
                                 PurchaseInvoiceRepository purchaseRepo,
                                 BankAccountRepository bankRepo,
                                 ApplicationEventPublisher publisher) {
        this.paymentRepo = paymentRepo;
        this.salesRepo = salesRepo;
        this.purchaseRepo = purchaseRepo;
        this.bankRepo = bankRepo;
        this.publisher = publisher;
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public Payment post(Payment payment, Long userId) {
        Long tenantId = payment.getTenantId();

        // 1. Idempotency check
        if (payment.getIdempotencyKey() != null) {
            var existing = paymentRepo.findByTenantIdAndIdempotencyKey(
                tenantId, payment.getIdempotencyKey());
            if (existing.isPresent()) {
                log.info("Idempotent replay: payment {}", existing.get().getId());
                return existing.get();
            }
        }

        // 2. Validate bank account if payment method requires it
        if (payment.getPaymentMethod() != PaymentMethod.CASH) {
            if (payment.getBankAccountId() == null) {
                throw new InvalidPaymentException(
                    "Bank account required for method " + payment.getPaymentMethod());
            }
            var ba = bankRepo.findById(payment.getBankAccountId())
                .orElseThrow(() -> new InvalidPaymentException("Bank account not found"));
            if (!ba.getTenantId().equals(tenantId)) {
                throw new InvalidPaymentException("Bank account not found");
            }
        }

        // 3. Validate allocations and update invoices
        BigDecimal totalAllocated = BigDecimal.ZERO;
        if (payment.getAllocations() != null) {
            for (PaymentAllocation a : payment.getAllocations()) {
                validateAndApplyAllocation(tenantId, payment.getPartyType(), a);
                totalAllocated = totalAllocated.add(a.getAllocatedAmount());
            }
        }

        if (totalAllocated.compareTo(payment.getAmount()) > 0) {
            throw new InvalidPaymentException(
                "Allocated amount " + totalAllocated + " exceeds payment amount " + payment.getAmount());
        }
        payment.setUnallocatedAmount(payment.getAmount().subtract(totalAllocated));

        // 4. Save payment
        payment.setStatus(PaymentStatus.POSTED);
        payment.setPostedAt(Instant.now());
        payment.setPostedBy(userId);

        Payment saved = paymentRepo.save(payment);

        // 5. Publish event - listener in financial-core creates and posts journal entry
        publisher.publishEvent(new PaymentPostedEvent(
            saved.getTenantId(),
            saved.getId(),
            saved.getPaymentNumber(),
            saved.getPaymentDate(),
            saved.getAmount(),
            saved.getCurrency(),
            saved.getPartyType(),
            saved.getPartyId(),
            saved.getPaymentMethod(),
            saved.getBankAccountId(),
            saved.getReferenceNo(),
            userId
        ));

        Payment reloaded = paymentRepo.findById(saved.getId()).orElse(saved);
        log.info("Posted payment {} for tenant {} (amount {})",
            reloaded.getPaymentNumber(), tenantId, reloaded.getAmount());
        return reloaded;
    }

    private void validateAndApplyAllocation(Long tenantId, PartyType partyType, PaymentAllocation a) {
        if (a.getAllocatedAmount() == null || a.getAllocatedAmount().signum() <= 0) {
            throw new InvalidPaymentException("Allocated amount must be > 0");
        }

        if ("SALES".equalsIgnoreCase(a.getInvoiceType())) {
            if (partyType != PartyType.CUSTOMER) {
                throw new InvalidPaymentException(
                    "Customer payments can only be allocated to sales invoices");
            }
            SalesInvoice inv = salesRepo.findById(a.getInvoiceId())
                .orElseThrow(() -> new InvalidPaymentException("Invoice not found"));
            if (!inv.getTenantId().equals(tenantId)) {
                throw new InvalidPaymentException("Invoice not found");
            }
            BigDecimal paidSoFar = inv.getAmountPaid() != null ? inv.getAmountPaid() : BigDecimal.ZERO;
            BigDecimal remaining = inv.getTotalAmount().subtract(paidSoFar);
            if (a.getAllocatedAmount().compareTo(remaining) > 0) {
                throw new InvalidPaymentException(
                    "Allocation " + a.getAllocatedAmount() + " exceeds outstanding " + remaining
                        + " on invoice " + inv.getInvoiceNumber());
            }
            inv.setAmountPaid(paidSoFar.add(a.getAllocatedAmount()));
            salesRepo.save(inv);
        } else if ("PURCHASE".equalsIgnoreCase(a.getInvoiceType())) {
            if (partyType != PartyType.VENDOR) {
                throw new InvalidPaymentException(
                    "Vendor payments can only be allocated to purchase invoices");
            }
            PurchaseInvoice inv = purchaseRepo.findById(a.getInvoiceId())
                .orElseThrow(() -> new InvalidPaymentException("Invoice not found"));
            if (!inv.getTenantId().equals(tenantId)) {
                throw new InvalidPaymentException("Invoice not found");
            }
            BigDecimal paidSoFar = inv.getAmountPaid() != null ? inv.getAmountPaid() : BigDecimal.ZERO;
            BigDecimal remaining = inv.getTotalAmount().subtract(paidSoFar);
            if (a.getAllocatedAmount().compareTo(remaining) > 0) {
                throw new InvalidPaymentException(
                    "Allocation " + a.getAllocatedAmount() + " exceeds outstanding " + remaining
                        + " on invoice " + inv.getInvoiceNumber());
            }
            inv.setAmountPaid(paidSoFar.add(a.getAllocatedAmount()));
            purchaseRepo.save(inv);
        } else {
            throw new InvalidPaymentException("Invalid invoice type: " + a.getInvoiceType());
        }
    }
}
