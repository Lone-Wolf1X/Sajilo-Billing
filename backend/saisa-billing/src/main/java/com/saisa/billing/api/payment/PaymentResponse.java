package com.saisa.billing.api.payment;

import com.saisa.billing.domain.payment.Payment;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record PaymentResponse(
    Long id,
    String paymentNumber,
    LocalDate paymentDate,
    BigDecimal amount,
    BigDecimal unallocatedAmount,
    String partyType,
    Long partyId,
    String paymentMethod,
    Long bankAccountId,
    String referenceNo,
    String status,
    Long journalEntryId,
    List<Allocation> allocations
) {
    public record Allocation(String invoiceType, Long invoiceId, BigDecimal amount) {}

    public static PaymentResponse from(Payment p, List<Allocation> allocs) {
        return new PaymentResponse(
            p.getId(),
            p.getPaymentNumber(),
            p.getPaymentDate(),
            p.getAmount(),
            p.getUnallocatedAmount(),
            p.getPartyType().name(),
            p.getPartyId(),
            p.getPaymentMethod().name(),
            p.getBankAccountId(),
            p.getReferenceNo(),
            p.getStatus().name(),
            p.getJournalEntryId(),
            allocs
        );
    }
}

