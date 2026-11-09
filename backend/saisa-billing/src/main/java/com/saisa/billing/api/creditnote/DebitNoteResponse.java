package com.saisa.billing.api.creditnote;

import com.saisa.billing.domain.creditnote.DebitNote;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record DebitNoteResponse(
    Long id,
    String debitNoteNumber,
    LocalDate debitNoteDate,
    Long vendorId,
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

    public static DebitNoteResponse from(DebitNote dn) {
        return new DebitNoteResponse(
            dn.getId(),
            dn.getDebitNoteNumber(),
            dn.getDebitNoteDate(),
            dn.getVendorId(),
            dn.getOriginalInvoiceId(),
            dn.getReason(),
            dn.getStatus() != null ? dn.getStatus().name() : null,
            dn.getSubtotal(),
            dn.getTaxAmount(),
            dn.getTotalAmount(),
            dn.getCurrency(),
            dn.getJournalEntryId(),
            dn.getLines().stream().map(l -> new Line(
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

