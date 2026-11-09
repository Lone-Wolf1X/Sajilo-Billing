package com.saisa.billing.api.dto;

import com.saisa.billing.domain.invoice.SalesInvoice;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record SalesInvoiceResponse(
    Long id,
    String invoiceNumber,
    LocalDate invoiceDate,
    LocalDate dueDate,
    Long customerId,
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
        String description,
        BigDecimal quantity,
        BigDecimal unitPrice,
        BigDecimal taxRate,
        BigDecimal lineSubtotal,
        BigDecimal lineTax,
        BigDecimal lineTotal
    ) {}

    public static SalesInvoiceResponse from(SalesInvoice i, List<Line> lines) {
        return new SalesInvoiceResponse(
            i.getId(),
            i.getInvoiceNumber(),
            i.getInvoiceDate(),
            i.getDueDate(),
            i.getCustomerId(),
            i.getStatus() != null ? i.getStatus().name() : null,
            i.getSubtotal(),
            i.getTaxAmount(),
            i.getTotalAmount(),
            i.getCurrency(),
            i.getJournalEntryId(),
            lines);
    }
}
