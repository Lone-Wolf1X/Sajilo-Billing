package com.saisa.billing.api.dto;

import com.saisa.billing.domain.invoice.PurchaseInvoice;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record PurchaseInvoiceResponse(
    Long id,
    String invoiceNumber,
    String vendorInvoiceNo,
    LocalDate invoiceDate,
    LocalDate dueDate,
    Long vendorId,
    Long warehouseId,
    String status,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal totalAmount,
    BigDecimal amountPaid,
    BigDecimal amountOutstanding,
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

    public static PurchaseInvoiceResponse from(PurchaseInvoice i, List<Line> lines) {
        BigDecimal paid = i.getAmountPaid() != null ? i.getAmountPaid() : BigDecimal.ZERO;
        BigDecimal outstanding = i.getAmountOutstanding();
        return new PurchaseInvoiceResponse(
            i.getId(),
            i.getInvoiceNumber(),
            i.getVendorInvoiceNo(),
            i.getInvoiceDate(),
            i.getDueDate(),
            i.getVendorId(),
            i.getWarehouseId(),
            i.getStatus() != null ? i.getStatus().name() : null,
            i.getSubtotal(),
            i.getTaxAmount(),
            i.getTotalAmount(),
            paid,
            outstanding,
            i.getCurrency(),
            i.getJournalEntryId(),
            lines);
    }
}

