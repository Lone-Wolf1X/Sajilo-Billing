package com.saisa.billing.application;

import com.saisa.billing.domain.event.PurchaseInvoicePostedEvent;
import com.saisa.billing.domain.event.SalesInvoicePostedEvent;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.domain.invoice.PurchaseInvoice;
import com.saisa.billing.domain.invoice.PurchaseInvoiceLine;
import com.saisa.billing.domain.invoice.SalesInvoice;
import com.saisa.billing.domain.invoice.SalesInvoiceLine;
import com.saisa.billing.infrastructure.persistence.PurchaseInvoiceRepository;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BillingService {

    private static final Logger log = LoggerFactory.getLogger(BillingService.class);

    private final SalesInvoiceRepository salesRepo;
    private final PurchaseInvoiceRepository purchaseRepo;
    private final ApplicationEventPublisher publisher;

    public BillingService(SalesInvoiceRepository salesRepo,
                          PurchaseInvoiceRepository purchaseRepo,
                          ApplicationEventPublisher publisher) {
        this.salesRepo = salesRepo;
        this.purchaseRepo = purchaseRepo;
        this.publisher = publisher;
    }

    /**
     * Create a sales invoice and immediately post it.
     * Invoicing and journal posting are atomic - if either fails, both roll back.
     *
     * The invoice total is computed line-by-line with HALF_EVEN rounding,
     * so the sum of rounded line totals equals the invoice total exactly.
     */
    @Transactional
    public SalesInvoice createAndPostSalesInvoice(
            SalesInvoice draft, Long userId) {

        draft.setTenantId(currentTenantId());
        computeSalesTotals(draft);
        draft.setStatus(InvoiceStatus.POSTED);
        draft.setPostedAt(Instant.now());
        draft.setPostedBy(userId);

        SalesInvoice saved = salesRepo.save(draft);

        // Publish event - listener will post journal entry in same transaction.
        var salesLineSummaries = saved.getLines().stream()
            .map(l -> new SalesInvoicePostedEvent.LineSummary(
                l.getItemId(), l.getQuantity(), l.getUnitPrice(),
                l.getLineSubtotal(), l.getLineTax(), l.getLineTotal()))
            .toList();

        publisher.publishEvent(new SalesInvoicePostedEvent(
            saved.getTenantId(),
            saved.getId(),
            saved.getInvoiceNumber(),
            saved.getInvoiceDate(),
            saved.getSubtotal(),
            saved.getTaxAmount(),
            saved.getTotalAmount(),
            saved.getCurrency(),
            userId,
            saved.getWarehouseId(),
            salesLineSummaries));

        return salesRepo.findById(saved.getId()).orElse(saved);
    }

    @Transactional
    public PurchaseInvoice createAndPostPurchaseInvoice(
            PurchaseInvoice draft, Long userId) {

        draft.setTenantId(currentTenantId());
        computePurchaseTotals(draft);
        draft.setStatus(InvoiceStatus.POSTED);
        draft.setPostedAt(Instant.now());
        draft.setPostedBy(userId);

        PurchaseInvoice saved = purchaseRepo.save(draft);

        var purchaseLineSummaries = saved.getLines().stream()
            .map(l -> new PurchaseInvoicePostedEvent.LineSummary(
                l.getItemId(), l.getQuantity(), l.getUnitPrice(),
                l.getLineSubtotal(), l.getLineTax(), l.getLineTotal()))
            .toList();

        publisher.publishEvent(new PurchaseInvoicePostedEvent(
            saved.getTenantId(),
            saved.getId(),
            saved.getInvoiceNumber(),
            saved.getInvoiceDate(),
            saved.getSubtotal(),
            saved.getTaxAmount(),
            saved.getTotalAmount(),
            saved.getCurrency(),
            userId,
            saved.getWarehouseId(),
            purchaseLineSummaries));

        return purchaseRepo.findById(saved.getId()).orElse(saved);
    }

    private void computeSalesTotals(SalesInvoice inv) {
        BigDecimal subtotal = BigDecimal.ZERO;
        BigDecimal taxTotal = BigDecimal.ZERO;
        BigDecimal grandTotal = BigDecimal.ZERO;

        for (SalesInvoiceLine line : inv.getLines()) {
            line.setTenantId(inv.getTenantId());
            // Subtotal = qty * unitPrice, rounded to 4dp
            BigDecimal lineSubtotal = line.getQuantity().multiply(line.getUnitPrice())
                .setScale(4, RoundingMode.HALF_EVEN);
            // Tax = lineSubtotal * rate, rounded to 4dp
            BigDecimal lineTax = lineSubtotal.multiply(line.getTaxRate())
                .setScale(4, RoundingMode.HALF_EVEN);
            BigDecimal lineTotal = lineSubtotal.add(lineTax);

            line.setLineSubtotal(lineSubtotal);
            line.setLineTax(lineTax);
            line.setLineTotal(lineTotal);

            subtotal = subtotal.add(lineSubtotal);
            taxTotal = taxTotal.add(lineTax);
            grandTotal = grandTotal.add(lineTotal);
        }

        inv.setSubtotal(subtotal);
        inv.setTaxAmount(taxTotal);
        inv.setTotalAmount(grandTotal);
    }

    private void computePurchaseTotals(PurchaseInvoice inv) {
        BigDecimal subtotal = BigDecimal.ZERO;
        BigDecimal taxTotal = BigDecimal.ZERO;
        BigDecimal grandTotal = BigDecimal.ZERO;

        for (PurchaseInvoiceLine line : inv.getLines()) {
            line.setTenantId(inv.getTenantId());
            BigDecimal lineSubtotal = line.getQuantity().multiply(line.getUnitPrice())
                .setScale(4, RoundingMode.HALF_EVEN);
            BigDecimal lineTax = lineSubtotal.multiply(line.getTaxRate())
                .setScale(4, RoundingMode.HALF_EVEN);
            BigDecimal lineTotal = lineSubtotal.add(lineTax);

            line.setLineSubtotal(lineSubtotal);
            line.setLineTax(lineTax);
            line.setLineTotal(lineTotal);

            subtotal = subtotal.add(lineSubtotal);
            taxTotal = taxTotal.add(lineTax);
            grandTotal = grandTotal.add(lineTotal);
        }

        inv.setSubtotal(subtotal);
        inv.setTaxAmount(taxTotal);
        inv.setTotalAmount(grandTotal);
    }

    private Long currentTenantId() {
        return com.saisa.common.tenant.TenantContext.getCurrentTenantId();
    }
}
