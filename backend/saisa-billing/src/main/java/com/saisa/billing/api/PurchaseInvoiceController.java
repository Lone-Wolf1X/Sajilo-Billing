package com.saisa.billing.api;

import com.saisa.billing.api.dto.CreatePurchaseInvoiceRequest;
import com.saisa.billing.api.dto.PurchaseInvoiceResponse;
import com.saisa.billing.application.BillingService;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.domain.invoice.PurchaseInvoice;
import com.saisa.billing.domain.invoice.PurchaseInvoiceLine;
import com.saisa.billing.infrastructure.persistence.PurchaseInvoiceRepository;
import com.saisa.billing.infrastructure.persistence.VendorRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/purchase-invoices")
public class PurchaseInvoiceController {

    private final BillingService billingService;
    private final PurchaseInvoiceRepository purchaseRepo;
    private final VendorRepository vendorRepo;

    public PurchaseInvoiceController(BillingService billingService,
                                     PurchaseInvoiceRepository purchaseRepo,
                                     VendorRepository vendorRepo) {
        this.billingService = billingService;
        this.purchaseRepo = purchaseRepo;
        this.vendorRepo = vendorRepo;
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<PurchaseInvoiceResponse> list(
            @RequestParam(required = false) LocalDate from,
            @RequestParam(required = false) LocalDate to,
            @RequestParam(required = false) Long vendorId,
            @RequestParam(required = false) InvoiceStatus status,
            @RequestParam(defaultValue = "50") int limit) {
        Long tenantId = TenantContext.getCurrentTenantId();
        List<PurchaseInvoice> invoices = purchaseRepo.findWithFilters(
            tenantId, from, to, vendorId, status,
            PageRequest.of(0, Math.min(limit, 200)));

        return invoices.stream()
            .map(i -> PurchaseInvoiceResponse.from(i, List.of()))
            .toList();
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<PurchaseInvoiceResponse> create(
            @Valid @RequestBody CreatePurchaseInvoiceRequest req) {

        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        // Idempotency
        if (req.idempotencyKey() != null) {
            var existing = purchaseRepo.findByTenantIdAndIdempotencyKey(tenantId, req.idempotencyKey());
            if (existing.isPresent()) {
                PurchaseInvoice e = existing.get();
                return ResponseEntity.ok(PurchaseInvoiceResponse.from(e, mapLines(e)));
            }
        }

        // Vendor ownership check
        var vendor = vendorRepo.findById(req.vendorId())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Vendor not found"));
        if (!vendor.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Vendor not found");
        }

        PurchaseInvoice inv = new PurchaseInvoice();
        inv.setTenantId(tenantId);
        inv.setInvoiceNumber(req.invoiceNumber());
        inv.setVendorInvoiceNo(req.vendorInvoiceNo());
        inv.setInvoiceDate(req.invoiceDate());
        inv.setDueDate(req.dueDate());
        inv.setVendorId(req.vendorId());
        inv.setWarehouseId(req.warehouseId());
        inv.setNotes(req.notes());
        inv.setIdempotencyKey(req.idempotencyKey());
        inv.setCreatedBy(userId);

        for (var l : req.lines()) {
            PurchaseInvoiceLine line = new PurchaseInvoiceLine();
            line.setItemId(l.itemId());
            line.setDescription(l.description());
            line.setQuantity(new BigDecimal(l.quantity()));
            line.setUnitPrice(new BigDecimal(l.unitPrice()));
            line.setTaxRate(new BigDecimal(l.taxRate()));
            inv.addLine(line);
        }

        PurchaseInvoice saved = billingService.createAndPostPurchaseInvoice(inv, userId);
        saved = purchaseRepo.findByIdWithLines(saved.getId()).orElse(saved);

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(PurchaseInvoiceResponse.from(saved, mapLines(saved)));
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public PurchaseInvoiceResponse get(@PathVariable Long id) {
        PurchaseInvoice inv = purchaseRepo.findByIdWithLines(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found"));
        if (!inv.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found");
        }
        return PurchaseInvoiceResponse.from(inv, mapLines(inv));
    }

    private java.util.List<PurchaseInvoiceResponse.Line> mapLines(PurchaseInvoice i) {
        return i.getLines().stream().map(l -> new PurchaseInvoiceResponse.Line(
            l.getLineNumber(), l.getItemId(), l.getDescription(), l.getQuantity(),
            l.getUnitPrice(), l.getTaxRate(), l.getLineSubtotal(),
            l.getLineTax(), l.getLineTotal())).toList();
    }
}

