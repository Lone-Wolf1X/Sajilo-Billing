package com.saisa.billing.domain.invoice;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "customers")
@Getter
@Setter
public class Customer extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "customer_code", nullable = false, length = 64)
    private String customerCode;

    @Column(name = "customer_name", nullable = false, length = 255)
    private String customerName;

    @Column(name = "gstin", length = 15)
    private String gstin;

    @Column(name = "pan", length = 10)
    private String pan;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "phone", length = 32)
    private String phone;

    @Column(name = "billing_address", columnDefinition = "TEXT")
    private String billingAddress;

    @Column(name = "state", length = 100)
    private String state;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;
}
