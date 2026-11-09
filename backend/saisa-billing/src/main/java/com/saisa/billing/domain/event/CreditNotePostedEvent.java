package com.saisa.billing.domain.event;

import java.math.BigDecimal;
import java.time.LocalDate;

public record CreditNotePostedEvent(
    Long tenantId,
    Long creditNoteId,
    String creditNoteNumber,
    LocalDate creditNoteDate,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal totalAmount,
    String currency,
    Long originalInvoiceId,
    Long postedBy
) {}

