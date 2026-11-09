package com.saisa.billing.domain.event;

import java.math.BigDecimal;
import java.time.LocalDate;

public record DebitNotePostedEvent(
    Long tenantId,
    Long debitNoteId,
    String debitNoteNumber,
    LocalDate debitNoteDate,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal totalAmount,
    String currency,
    Long originalInvoiceId,
    Long postedBy
) {}

