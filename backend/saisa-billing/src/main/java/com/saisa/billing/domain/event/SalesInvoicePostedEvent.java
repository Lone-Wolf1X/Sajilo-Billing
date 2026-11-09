package com.saisa.billing.domain.event;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Published when a sales invoice transitions to POSTED.
 *
 * Financial core listens and creates the corresponding journal entry:
 *   AR Dr total
 *     Sales Cr subtotal
 *     GST Output Cr tax
 *
 * Inventory module listens and posts stock movements and COGS entry:
 *   COGS Dr
 *     Inventory Asset Cr
 */
public record SalesInvoicePostedEvent(
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

    public SalesInvoicePostedEvent(
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
