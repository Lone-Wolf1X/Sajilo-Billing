package com.saisa.billing.api;

import com.saisa.billing.api.dto.CreateSalesInvoiceRequest;
import com.saisa.billing.api.dto.SalesInvoiceResponse;
import com.saisa.billing.application.BillingService;
import com.saisa.billing.domain.invoice.SalesInvoice;
import com.saisa.billing.domain.invoice.SalesInvoiceLine;
import com.saisa.billing.infrastructure.persistence.CustomerRepository;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/sales-invoices")
public class SalesInvoiceController {

    private final BillingService billingService;
    private final SalesInvoiceRepository salesRepo;
    private final CustomerRepository customerRepo;

    public SalesInvoiceController(BillingService billingService,
                                  SalesInvoiceRepository salesRepo,
                                  CustomerRepository customerRepo) {
        this.billingService = billingService;
        this.salesRepo = salesRepo;
        this.customerRepo = customerRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<SalesInvoiceResponse> create(
            @Valid @RequestBody CreateSalesInvoiceRequest req) {

        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        // Idempotency
        if (req.idempotencyKey() != null) {
            var existing = salesRepo.findByTenantIdAndIdempotencyKey(tenantId, req.idempotencyKey());
            if (existing.isPresent()) {
                SalesInvoice e = existing.get();
                return ResponseEntity.ok(SalesInvoiceResponse.from(e, mapLines(e)));
            }
        }

        // Customer ownership check
        var customer = customerRepo.findById(req.customerId())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Customer not found"));
        if (!customer.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Customer not found");
        }

        SalesInvoice inv = new SalesInvoice();
        inv.setTenantId(tenantId);
        inv.setInvoiceNumber(req.invoiceNumber());
        inv.setInvoiceDate(req.invoiceDate());
        inv.setDueDate(req.dueDate());
        inv.setCustomerId(req.customerId());
        inv.setNotes(req.notes());
        inv.setIdempotencyKey(req.idempotencyKey());
        inv.setCreatedBy(userId);

        for (var l : req.lines()) {
            SalesInvoiceLine line = new SalesInvoiceLine();
            line.setDescription(l.description());
            line.setQuantity(new BigDecimal(l.quantity()));
            line.setUnitPrice(new BigDecimal(l.unitPrice()));
            line.setTaxRate(new BigDecimal(l.taxRate()));
            inv.addLine(line);
        }

        SalesInvoice saved = billingService.createAndPostSalesInvoice(inv, userId);
        saved = salesRepo.findByIdWithLines(saved.getId()).orElse(saved);

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(SalesInvoiceResponse.from(saved, mapLines(saved)));
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public SalesInvoiceResponse get(@PathVariable Long id) {
        SalesInvoice inv = salesRepo.findByIdWithLines(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found"));
        if (!inv.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found");
        }
        return SalesInvoiceResponse.from(inv, mapLines(inv));
    }

    private java.util.List<SalesInvoiceResponse.Line> mapLines(SalesInvoice i) {
        return i.getLines().stream().map(l -> new SalesInvoiceResponse.Line(
            l.getLineNumber(), l.getDescription(), l.getQuantity(),
            l.getUnitPrice(), l.getTaxRate(), l.getLineSubtotal(),
            l.getLineTax(), l.getLineTotal())).toList();
    }
}
