package com.saisa.common.tenant;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import java.time.Instant;
import java.time.LocalDate;
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

    @Column(name = "company_name_nepali", length = 255)
    private String companyNameNepali;

    @Column(name = "legal_name", length = 255)
    private String legalName;

    @Column(name = "gstin", length = 15)
    private String gstin;

    @Column(name = "pan", length = 20)
    private String pan;

    @Column(name = "pan_vat_no", length = 20)
    private String panVatNo;

    @Column(name = "pan_vat_date")
    private LocalDate panVatDate;

    @Column(name = "registration_authority", length = 100)
    private String registrationAuthority;

    @Column(name = "registration_no", length = 100)
    private String registrationNo;

    @Column(name = "registration_date")
    private LocalDate registrationDate;

    @Column(name = "province", length = 100)
    private String province;

    @Column(name = "district", length = 100)
    private String district;

    @Column(name = "municipality_vdc", length = 150)
    private String municipalityVdc;

    @Column(name = "ward_no")
    private Integer wardNo;

    @Column(name = "tole_street", length = 255)
    private String toleStreet;

    @Column(name = "address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "city", length = 100)
    private String city;

    @Column(name = "state", length = 100)
    private String state;

    @Column(name = "country", nullable = false, length = 64)
    private String country = "Nepal";

    @Column(name = "pincode", length = 20)
    private String pincode;

    @Column(name = "phone", length = 32)
    private String phone;

    @Column(name = "email", length = 255)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(name = "incorporation_type", length = 50)
    private IncorporationType incorporationType;

    @Enumerated(EnumType.STRING)
    @Column(name = "business_nature", length = 50)
    private BusinessNature businessNature;

    @Column(name = "authorized_person_name", length = 255)
    private String authorizedPersonName;

    @Column(name = "authorized_person_designation", length = 100)
    private String authorizedPersonDesignation;

    @Column(name = "authorized_person_phone", length = 20)
    private String authorizedPersonPhone;

    @Column(name = "authorized_person_email", length = 255)
    private String authorizedPersonEmail;

    @Column(name = "setup_completed", nullable = false)
    private boolean setupCompleted = false;

    @Column(name = "setup_completed_at")
    private Instant setupCompletedAt;

    @Column(name = "setup_step", nullable = false)
    private int setupStep = 1;

    @Column(name = "fiscal_year_start_month", nullable = false)
    private int fiscalYearStartMonth = 4;

    @Column(name = "status", nullable = false, length = 16)
    private String status = "ACTIVE";

    public boolean isActive() {
        return "ACTIVE".equals(status);
    }
}
