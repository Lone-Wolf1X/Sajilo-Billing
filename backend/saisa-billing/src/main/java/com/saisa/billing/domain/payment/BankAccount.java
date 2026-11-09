package com.saisa.billing.domain.payment;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "bank_accounts")
@Getter
@Setter
public class BankAccount extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "account_code", nullable = false, length = 64)
    private String accountCode;

    @Column(name = "account_name", nullable = false, length = 255)
    private String accountName;

    @Column(name = "bank_name", length = 255)
    private String bankName;

    @Column(name = "account_number", length = 64)
    private String accountNumber;

    @Column(name = "ifsc_code", length = 16)
    private String ifscCode;

    @Column(name = "gl_account_id", nullable = false)
    private Long glAccountId;

    @Column(name = "is_default", nullable = false)
    private boolean defaultAccount = false;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;
}

