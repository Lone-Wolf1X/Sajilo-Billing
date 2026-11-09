package com.saisa.billing.api.payment;

import com.saisa.billing.domain.payment.PartyType;
import com.saisa.billing.domain.payment.PaymentMethod;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

public record CreatePaymentRequest(
    @NotBlank String paymentNumber,
    @NotNull LocalDate paymentDate,
    @NotBlank String amount,
    @NotNull PartyType partyType,
    @NotNull Long partyId,
    @NotNull PaymentMethod paymentMethod,
    Long bankAccountId,
    String referenceNo,
    String notes,
    String idempotencyKey,
    List<@Valid AllocationRequest> allocations
) {
    public record AllocationRequest(
        @NotBlank String invoiceType,  // SALES or PURCHASE
        @NotNull Long invoiceId,
        @NotBlank String amount
    ) {}
}

