package com.saisa.common.tenant;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "tenants")
@Getter
@Setter
public class Tenant extends BaseEntity {

    @Column(name = "tenant_code", nullable = false, length = 64)
    private String tenantCode;

    @Column(name = "company_name", nullable = false, length = 255)
    private String companyName;

    @Column(name = "legal_name", length = 255)
    private String legalName;

    @Column(name = "gstin", length = 15)
    private String gstin;

    @Column(name = "pan", length = 10)
    private String pan;

    @Column(name = "address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "city", length = 100)
    private String city;

    @Column(name = "state", length = 100)
    private String state;

    @Column(name = "country", nullable = false, length = 64)
    private String country = "India";

    @Column(name = "pincode", length = 20)
    private String pincode;

    @Column(name = "phone", length = 32)
    private String phone;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "fiscal_year_start_month", nullable = false)
    private int fiscalYearStartMonth = 4;

    @Column(name = "status", nullable = false, length = 16)
    private String status = "ACTIVE";

    public boolean isActive() {
        return "ACTIVE".equals(status);
    }
}
