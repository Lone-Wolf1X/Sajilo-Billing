package com.saisa.billing.api.creditnote;

import com.saisa.billing.application.creditnote.DebitNoteService;
import com.saisa.billing.domain.creditnote.DebitNote;
import com.saisa.billing.domain.creditnote.DebitNoteLine;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.infrastructure.persistence.DebitNoteRepository;
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
@RequestMapping("/api/v1/debit-notes")
@PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT', 'VIEWER')")
public class DebitNoteController {

    private final DebitNoteService service;
    private final DebitNoteRepository repo;

    public DebitNoteController(DebitNoteService service, DebitNoteRepository repo) {
        this.service = service;
        this.repo = repo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<DebitNoteResponse> create(
            @Valid @RequestBody CreateDebitNoteRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (req.idempotencyKey() != null) {
            var existing = repo.findByTenantIdAndIdempotencyKey(tenantId, req.idempotencyKey());
            if (existing.isPresent()) {
                DebitNote e = repo.findByIdWithLines(existing.get().getId()).orElse(existing.get());
                return ResponseEntity.ok(DebitNoteResponse.from(e));
            }
        }

        DebitNote dn = new DebitNote();
        dn.setTenantId(tenantId);
        dn.setDebitNoteNumber(req.debitNoteNumber());
        dn.setDebitNoteDate(req.debitNoteDate());
        dn.setVendorId(req.vendorId());
        dn.setOriginalInvoiceId(req.originalInvoiceId());
        dn.setReason(req.reason());
        dn.setIdempotencyKey(req.idempotencyKey());
        dn.setCreatedBy(userId);

        for (var l : req.lines()) {
            DebitNoteLine line = new DebitNoteLine();
            line.setItemId(l.itemId());
            line.setDescription(l.description());
            line.setQuantity(new BigDecimal(l.quantity()));
            line.setUnitPrice(new BigDecimal(l.unitPrice()));
            line.setTaxRate(new BigDecimal(l.taxRate()));
            dn.addLine(line);
        }

        DebitNote saved = service.createAndPost(dn, userId);
        DebitNote full = repo.findByIdWithLines(saved.getId()).orElse(saved);
        return ResponseEntity.status(HttpStatus.CREATED).body(DebitNoteResponse.from(full));
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<DebitNoteResponse> list(
            @RequestParam(required = false) LocalDate from,
            @RequestParam(required = false) LocalDate to,
            @RequestParam(required = false) Long vendorId,
            @RequestParam(required = false) InvoiceStatus status,
            @RequestParam(defaultValue = "50") int limit) {
        Long tenantId = TenantContext.getCurrentTenantId();
        List<DebitNote> notes = repo.findWithFilters(
            tenantId, from, to, vendorId, status,
            PageRequest.of(0, Math.min(limit, 200)));
        return notes.stream()
            .map(DebitNoteResponse::from)
            .toList();
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public DebitNoteResponse get(@PathVariable Long id) {
        DebitNote dn = repo.findByIdWithLines(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Debit note not found"));
        if (!dn.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Debit note not found");
        }
        return DebitNoteResponse.from(dn);
    }
}

