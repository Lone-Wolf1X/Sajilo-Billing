package com.saisa.billing.domain.event;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Published when a sales invoice transitions to POSTED.
 *
 * Financial core listens and creates the corresponding journal entry:
 *   AR Dr total
 *     Sales Cr subtotal
 *     GST Output Cr tax
 *
 * The listener does NOT know about billing-specific fields (customer name,
 * due date, etc.) - it only needs the amounts.
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
    Long postedBy
) {}
