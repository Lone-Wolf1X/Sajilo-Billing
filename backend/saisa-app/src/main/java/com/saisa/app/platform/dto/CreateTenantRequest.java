package com.saisa.app.platform.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateTenantRequest(
    @NotBlank @Size(max = 64) String tenantCode,
    @NotBlank @Size(max = 255) String companyName,
    @Size(max = 255) String companyNameNepali,
    @Size(max = 255) String legalName,

    // Admin user for this tenant
    @NotBlank @Size(min = 3, max = 64) String adminUsername,
    @NotBlank @Email String adminEmail,
    @Size(max = 255) String adminFullName,
    @Size(min = 8, max = 128) String adminPassword,

    // Optional initial profile fields
    String registrationNo,
    String panVatNo,
    String province,
    String district,
    String municipalityVdc,
    String wardNo,
    String incorporationType,
    String businessNature,

    // License binding during onboarding
    String licensePlan,
    Integer licenseDurationDays,
    Integer maxUsers
) {}

