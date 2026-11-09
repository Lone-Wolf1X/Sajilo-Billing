package com.saisa.billing.domain.event;

import com.saisa.billing.domain.payment.PartyType;
import com.saisa.billing.domain.payment.PaymentMethod;
import java.math.BigDecimal;
import java.time.LocalDate;

public record PaymentPostedEvent(
    Long tenantId,
    Long paymentId,
    String paymentNumber,
    LocalDate paymentDate,
    BigDecimal amount,
    String currency,
    PartyType partyType,
    Long partyId,
    PaymentMethod paymentMethod,
    Long bankAccountId,
    String referenceNo,
    Long postedBy
) {}

