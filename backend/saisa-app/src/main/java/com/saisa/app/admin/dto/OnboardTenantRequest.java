package com.saisa.app.admin.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record OnboardTenantRequest(
    @NotBlank String companyName,
    String companyNameNepali,
    @NotBlank String tenantCode,
    String panVatNo,
    String phone,
    String email,
    String province,
    String district,
    String address,
    @NotBlank String adminUsername,
    @NotBlank String adminEmail,
    @NotBlank @Size(min = 6) String adminPassword,
    @NotBlank String adminFullName
) {}
