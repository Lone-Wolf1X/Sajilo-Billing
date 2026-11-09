package com.saisa.billing.application.creditnote;

import com.saisa.billing.domain.creditnote.CreditNote;
import com.saisa.billing.domain.creditnote.CreditNoteLine;
import com.saisa.billing.domain.event.CreditNotePostedEvent;
import com.saisa.billing.domain.exception.InvalidCreditNoteException;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.domain.invoice.SalesInvoice;
import com.saisa.billing.infrastructure.persistence.CreditNoteRepository;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CreditNoteService {

    private final CreditNoteRepository creditRepo;
    private final SalesInvoiceRepository salesRepo;
    private final ApplicationEventPublisher publisher;

    public CreditNoteService(CreditNoteRepository creditRepo,
                             SalesInvoiceRepository salesRepo,
                             ApplicationEventPublisher publisher) {
        this.creditRepo = creditRepo;
        this.salesRepo = salesRepo;
        this.publisher = publisher;
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public CreditNote createAndPost(CreditNote draft, Long userId) {
        Long tenantId = draft.getTenantId();

        // Idempotency
        if (draft.getIdempotencyKey() != null) {
            var existing = creditRepo.findByTenantIdAndIdempotencyKey(
                tenantId, draft.getIdempotencyKey());
            if (existing.isPresent()) return existing.get();
        }

        // Compute totals with per-line rounding
        computeTotals(draft);

        // If linked to invoice, ensure it doesn't over-credit
        if (draft.getOriginalInvoiceId() != null) {
            SalesInvoice inv = salesRepo.findById(draft.getOriginalInvoiceId())
                .orElseThrow(() -> new InvalidCreditNoteException("Original invoice not found"));
            if (!inv.getTenantId().equals(tenantId)) {
                throw new InvalidCreditNoteException("Original invoice not found");
            }
            if (!inv.getCustomerId().equals(draft.getCustomerId())) {
                throw new InvalidCreditNoteException(
                    "Credit note customer does not match invoice customer");
            }
            BigDecimal currentCredited = inv.getAmountCredited() != null ? inv.getAmountCredited() : BigDecimal.ZERO;
            BigDecimal currentPaid = inv.getAmountPaid() != null ? inv.getAmountPaid() : BigDecimal.ZERO;
            BigDecimal newCredited = currentCredited.add(draft.getTotalAmount());
            if (newCredited.add(currentPaid).compareTo(inv.getTotalAmount()) > 0) {
                throw new InvalidCreditNoteException(
                    "Credit note would over-credit invoice " + inv.getInvoiceNumber()
                        + ": total " + inv.getTotalAmount()
                        + ", already paid " + currentPaid
                        + ", already credited " + currentCredited);
            }
            inv.setAmountCredited(newCredited);
            salesRepo.save(inv);
        }

        draft.setStatus(InvoiceStatus.POSTED);
        draft.setPostedAt(Instant.now());
        draft.setPostedBy(userId);

        CreditNote saved = creditRepo.save(draft);

        publisher.publishEvent(new CreditNotePostedEvent(
            tenantId, saved.getId(), saved.getCreditNoteNumber(),
            saved.getCreditNoteDate(), saved.getSubtotal(), saved.getTaxAmount(),
            saved.getTotalAmount(), saved.getCurrency(), saved.getOriginalInvoiceId(),
            userId));

        return creditRepo.findById(saved.getId()).orElse(saved);
    }

    private void computeTotals(CreditNote cn) {
        BigDecimal subtotal = BigDecimal.ZERO;
        BigDecimal tax = BigDecimal.ZERO;
        BigDecimal total = BigDecimal.ZERO;

        for (CreditNoteLine line : cn.getLines()) {
            line.setTenantId(cn.getTenantId());
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
        cn.setSubtotal(subtotal);
        cn.setTaxAmount(tax);
        cn.setTotalAmount(total);
    }
}

