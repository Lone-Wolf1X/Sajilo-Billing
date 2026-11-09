package com.saisa.billing.domain.event;

import java.math.BigDecimal;
import java.time.LocalDate;

public record PurchaseInvoicePostedEvent(
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
