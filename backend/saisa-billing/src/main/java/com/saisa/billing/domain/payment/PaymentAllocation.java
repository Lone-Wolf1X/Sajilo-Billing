package com.saisa.billing.domain.payment;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "payment_allocations")
@Getter
@Setter
public class PaymentAllocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "payment_id", nullable = false)
    private Payment payment;

    @Column(name = "invoice_type", nullable = false, length = 16)
    private String invoiceType;  // SALES or PURCHASE

    @Column(name = "invoice_id", nullable = false)
    private Long invoiceId;

    @Column(name = "allocated_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal allocatedAmount;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt = Instant.now();
}

