package com.saisa.billing.domain.creditnote;

import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "debit_notes")
@Getter
@Setter
public class DebitNote extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "debit_note_number", nullable = false, length = 64)
    private String debitNoteNumber;

    @Column(name = "debit_note_date", nullable = false)
    private LocalDate debitNoteDate;

    @Column(name = "vendor_id", nullable = false)
    private Long vendorId;

    @Column(name = "original_invoice_id")
    private Long originalInvoiceId;

    @Column(name = "reason", columnDefinition = "TEXT")
    private String reason;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 16)
    private InvoiceStatus status = InvoiceStatus.DRAFT;

    @Column(name = "subtotal", nullable = false, precision = 20, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "tax_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal taxAmount = BigDecimal.ZERO;

    @Column(name = "total_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Column(name = "currency", nullable = false, length = 3)
    private String currency = "INR";

    @Column(name = "journal_entry_id")
    private Long journalEntryId;

    @Column(name = "posted_at")
    private Instant postedAt;

    @Column(name = "posted_by")
    private Long postedBy;

    @Column(name = "idempotency_key", length = 128)
    private String idempotencyKey;

    @OneToMany(
        mappedBy = "debitNote",
        cascade = CascadeType.ALL,
        orphanRemoval = true,
        fetch = FetchType.LAZY
    )
    private List<DebitNoteLine> lines = new ArrayList<>();

    public void addLine(DebitNoteLine line) {
        line.setDebitNote(this);
        line.setTenantId(this.tenantId);
        line.setLineNumber(this.lines.size() + 1);
        this.lines.add(line);
    }
}

