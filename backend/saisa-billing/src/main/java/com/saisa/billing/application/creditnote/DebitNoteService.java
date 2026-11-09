package com.saisa.billing.application.creditnote;

import com.saisa.billing.domain.creditnote.DebitNote;
import com.saisa.billing.domain.creditnote.DebitNoteLine;
import com.saisa.billing.domain.event.DebitNotePostedEvent;
import com.saisa.billing.domain.exception.InvalidCreditNoteException;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.domain.invoice.PurchaseInvoice;
import com.saisa.billing.infrastructure.persistence.DebitNoteRepository;
import com.saisa.billing.infrastructure.persistence.PurchaseInvoiceRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DebitNoteService {

    private final DebitNoteRepository debitRepo;
    private final PurchaseInvoiceRepository purchaseRepo;
    private final ApplicationEventPublisher publisher;

    public DebitNoteService(DebitNoteRepository debitRepo,
                            PurchaseInvoiceRepository purchaseRepo,
                            ApplicationEventPublisher publisher) {
        this.debitRepo = debitRepo;
        this.purchaseRepo = purchaseRepo;
        this.publisher = publisher;
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public DebitNote createAndPost(DebitNote draft, Long userId) {
        Long tenantId = draft.getTenantId();

        if (draft.getIdempotencyKey() != null) {
            var existing = debitRepo.findByTenantIdAndIdempotencyKey(
                tenantId, draft.getIdempotencyKey());
            if (existing.isPresent()) return existing.get();
        }

        computeTotals(draft);

        if (draft.getOriginalInvoiceId() != null) {
            PurchaseInvoice inv = purchaseRepo.findById(draft.getOriginalInvoiceId())
                .orElseThrow(() -> new InvalidCreditNoteException("Original invoice not found"));
            if (!inv.getTenantId().equals(tenantId)) {
                throw new InvalidCreditNoteException("Original invoice not found");
            }
            if (!inv.getVendorId().equals(draft.getVendorId())) {
                throw new InvalidCreditNoteException(
                    "Debit note vendor does not match invoice vendor");
            }
            BigDecimal currentCredited = inv.getAmountCredited() != null ? inv.getAmountCredited() : BigDecimal.ZERO;
            BigDecimal currentPaid = inv.getAmountPaid() != null ? inv.getAmountPaid() : BigDecimal.ZERO;
            BigDecimal newCredited = currentCredited.add(draft.getTotalAmount());
            if (newCredited.add(currentPaid).compareTo(inv.getTotalAmount()) > 0) {
                throw new InvalidCreditNoteException(
                    "Debit note would over-credit invoice " + inv.getInvoiceNumber());
            }
            inv.setAmountCredited(newCredited);
            purchaseRepo.save(inv);
        }

        draft.setStatus(InvoiceStatus.POSTED);
        draft.setPostedAt(Instant.now());
        draft.setPostedBy(userId);

        DebitNote saved = debitRepo.save(draft);

        publisher.publishEvent(new DebitNotePostedEvent(
            tenantId, saved.getId(), saved.getDebitNoteNumber(),
            saved.getDebitNoteDate(), saved.getSubtotal(), saved.getTaxAmount(),
            saved.getTotalAmount(), saved.getCurrency(), saved.getOriginalInvoiceId(),
            userId));

        return debitRepo.findById(saved.getId()).orElse(saved);
    }

    private void computeTotals(DebitNote dn) {
        BigDecimal subtotal = BigDecimal.ZERO;
        BigDecimal tax = BigDecimal.ZERO;
        BigDecimal total = BigDecimal.ZERO;

        for (DebitNoteLine line : dn.getLines()) {
            line.setTenantId(dn.getTenantId());
            BigDecimal lineSub = line.getQuantity().multiply(line.getUnitPrice())
                .setScale(4, RoundingMode.HALF_EVEN);
            BigDecimal lineTax = lineSub.multiply(line.getTaxRate())
                .setScale(4, RoundingMode.HALF_EVEN);
            BigDecimal lineTotal = lineSub.add(lineTax);
            line.setLineSubtotal(lineSub);
            line.setLineTax(lineTax);
            line.setLineTotal(lineTotal);
            subtotal = subtotal.add(lineSub);
            tax = tax.add(lineTax);
            total = total.add(lineTotal);
        }
        dn.setSubtotal(subtotal);
        dn.setTaxAmount(tax);
        dn.setTotalAmount(total);
    }
}

