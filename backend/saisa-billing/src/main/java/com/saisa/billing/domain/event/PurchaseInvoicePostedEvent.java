package com.saisa.billing.domain.event;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record PurchaseInvoicePostedEvent(
    Long tenantId,
    Long invoiceId,
    String invoiceNumber,
    LocalDate invoiceDate,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal totalAmount,
    String currency,
    Long postedBy,
    Long warehouseId,
    List<LineSummary> lines
) {

    public record LineSummary(
        Long itemId,
        BigDecimal quantity,
        BigDecimal unitPrice,
        BigDecimal lineSubtotal,
        BigDecimal lineTax,
        BigDecimal lineTotal
    ) {}

    public PurchaseInvoicePostedEvent(
            Long tenantId,
            Long invoiceId,
            String invoiceNumber,
            LocalDate invoiceDate,
            BigDecimal subtotal,
            BigDecimal taxAmount,
            BigDecimal totalAmount,
            String currency,
            Long postedBy) {
        this(tenantId, invoiceId, invoiceNumber, invoiceDate, subtotal, taxAmount, totalAmount,
             currency, postedBy, null, List.of());
    }
}
