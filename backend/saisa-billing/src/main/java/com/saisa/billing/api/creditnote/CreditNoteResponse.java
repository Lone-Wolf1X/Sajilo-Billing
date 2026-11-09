package com.saisa.billing.api.creditnote;

import com.saisa.billing.domain.creditnote.CreditNote;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record CreditNoteResponse(
    Long id,
    String creditNoteNumber,
    LocalDate creditNoteDate,
    Long customerId,
    Long originalInvoiceId,
    String reason,
    String status,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal totalAmount,
    String currency,
    Long journalEntryId,
    List<Line> lines
) {
    public record Line(
        Integer lineNumber,
        Long itemId,
        String description,
        BigDecimal quantity,
        BigDecimal unitPrice,
        BigDecimal taxRate,
        BigDecimal lineSubtotal,
        BigDecimal lineTax,
        BigDecimal lineTotal
    ) {}

    public static CreditNoteResponse from(CreditNote cn) {
        return new CreditNoteResponse(
            cn.getId(),
            cn.getCreditNoteNumber(),
            cn.getCreditNoteDate(),
            cn.getCustomerId(),
            cn.getOriginalInvoiceId(),
            cn.getReason(),
            cn.getStatus() != null ? cn.getStatus().name() : null,
            cn.getSubtotal(),
            cn.getTaxAmount(),
            cn.getTotalAmount(),
            cn.getCurrency(),
            cn.getJournalEntryId(),
            cn.getLines().stream().map(l -> new Line(
                l.getLineNumber(),
                l.getItemId(),
                l.getDescription(),
                l.getQuantity(),
                l.getUnitPrice(),
                l.getTaxRate(),
                l.getLineSubtotal(),
                l.getLineTax(),
                l.getLineTotal()
            )).toList()
        );
    }
}

