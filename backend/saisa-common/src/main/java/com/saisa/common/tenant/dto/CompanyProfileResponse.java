package com.saisa.common.tenant.dto;

import com.saisa.common.tenant.BusinessNature;
import com.saisa.common.tenant.IncorporationType;
import com.saisa.common.tenant.Tenant;
import java.time.Instant;
import java.time.LocalDate;

public record CompanyProfileResponse(
    Long id,
    String tenantCode,
    String companyName,
    String companyNameNepali,
    String legalName,
    String gstin,
    String pan,
    String panVatNo,
    LocalDate panVatDate,
    String registrationAuthority,
    String registrationNo,
    LocalDate registrationDate,
    String province,
    String district,
    String municipalityVdc,
    Integer wardNo,
    String toleStreet,
    String address,
    String city,
    String state,
    String country,
    String pincode,
    String phone,
    String email,
    IncorporationType incorporationType,
    BusinessNature businessNature,
    String authorizedPersonName,
    String authorizedPersonDesignation,
    String authorizedPersonPhone,
    String authorizedPersonEmail,
    boolean setupCompleted,
    Instant setupCompletedAt,
    int setupStep
) {
    public static CompanyProfileResponse from(Tenant t) {
        return new CompanyProfileResponse(
            t.getId(),
            t.getTenantCode(),
            t.getCompanyName(),
            t.getCompanyNameNepali(),
            t.getLegalName(),
            t.getGstin(),
            t.getPan(),
            t.getPanVatNo(),
            t.getPanVatDate(),
            t.getRegistrationAuthority(),
            t.getRegistrationNo(),
            t.getRegistrationDate(),
            t.getProvince(),
            t.getDistrict(),
            t.getMunicipalityVdc(),
            t.getWardNo(),
            t.getToleStreet(),
            t.getAddress(),
            t.getCity(),
            t.getState(),
            t.getCountry(),
            t.getPincode(),
            t.getPhone(),
            t.getEmail(),
            t.getIncorporationType(),
            t.getBusinessNature(),
            t.getAuthorizedPersonName(),
            t.getAuthorizedPersonDesignation(),
            t.getAuthorizedPersonPhone(),
            t.getAuthorizedPersonEmail(),
            t.isSetupCompleted(),
            t.getSetupCompletedAt(),
            t.getSetupStep()
        );
    }
}
