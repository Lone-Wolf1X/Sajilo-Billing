package com.saisa.financial.domain.account;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * An account in the tenant's Chart of Accounts.
 *
 * Every journal line posts to exactly one ChartOfAccount.
 * Account types drive P&L and Balance Sheet reports.
 */
@Entity
@Table(name = "chart_of_accounts")
@Getter
@Setter
public class ChartOfAccount extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "account_code", nullable = false, length = 32)
    private String accountCode;

    @Column(name = "account_name", nullable = false, length = 255)
    private String accountName;

    @Enumerated(EnumType.STRING)
    @Column(name = "account_type", nullable = false, length = 32)
    private AccountType accountType;

    @Column(name = "parent_account_id")
    private Long parentAccountId;

    @Column(name = "is_system_account", nullable = false)
    private boolean systemAccount = false;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;
}
