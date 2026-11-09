package com.saisa.billing.api.creditnote;

import com.saisa.billing.application.creditnote.CreditNoteService;
import com.saisa.billing.domain.creditnote.CreditNote;
import com.saisa.billing.domain.creditnote.CreditNoteLine;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.infrastructure.persistence.CreditNoteRepository;
import com.saisa.common.audit.Auditable;
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
@RequestMapping("/api/v1/credit-notes")
public class CreditNoteController {

    private final CreditNoteService service;
    private final CreditNoteRepository repo;

    public CreditNoteController(CreditNoteService service, CreditNoteRepository repo) {
        this.service = service;
        this.repo = repo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    @Auditable(action = "CREDIT_NOTE_POSTED", entityType = "CreditNote")
    public ResponseEntity<CreditNoteResponse> create(
            @Valid @RequestBody CreateCreditNoteRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (req.idempotencyKey() != null) {
            var existing = repo.findByTenantIdAndIdempotencyKey(tenantId, req.idempotencyKey());
            if (existing.isPresent()) {
                CreditNote e = repo.findByIdWithLines(existing.get().getId()).orElse(existing.get());
                return ResponseEntity.ok(CreditNoteResponse.from(e));
            }
        }

        CreditNote cn = new CreditNote();
        cn.setTenantId(tenantId);
        cn.setCreditNoteNumber(req.creditNoteNumber());
        cn.setCreditNoteDate(req.creditNoteDate());
        cn.setCustomerId(req.customerId());
        cn.setOriginalInvoiceId(req.originalInvoiceId());
        cn.setReason(req.reason());
        cn.setIdempotencyKey(req.idempotencyKey());
        cn.setCreatedBy(userId);

        for (var l : req.lines()) {
            CreditNoteLine line = new CreditNoteLine();
            line.setItemId(l.itemId());
            line.setDescription(l.description());
            line.setQuantity(new BigDecimal(l.quantity()));
            line.setUnitPrice(new BigDecimal(l.unitPrice()));
            line.setTaxRate(new BigDecimal(l.taxRate()));
            cn.addLine(line);
        }

        CreditNote saved = service.createAndPost(cn, userId);
        CreditNote full = repo.findByIdWithLines(saved.getId()).orElse(saved);
        return ResponseEntity.status(HttpStatus.CREATED).body(CreditNoteResponse.from(full));
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<CreditNoteResponse> list(
            @RequestParam(required = false) LocalDate from,
            @RequestParam(required = false) LocalDate to,
            @RequestParam(required = false) Long customerId,
            @RequestParam(required = false) InvoiceStatus status,
            @RequestParam(defaultValue = "50") int limit) {
        Long tenantId = TenantContext.getCurrentTenantId();
        List<CreditNote> notes = repo.findWithFilters(
            tenantId, from, to, customerId, status,
            PageRequest.of(0, Math.min(limit, 200)));
        return notes.stream()
            .map(CreditNoteResponse::from)
            .toList();
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public CreditNoteResponse get(@PathVariable Long id) {
        CreditNote cn = repo.findByIdWithLines(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Credit note not found"));
        if (!cn.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Credit note not found");
        }
        return CreditNoteResponse.from(cn);
    }
}

