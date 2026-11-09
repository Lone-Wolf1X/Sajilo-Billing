package com.saisa.common.tenant.dto;

import com.saisa.common.tenant.BusinessNature;
import com.saisa.common.tenant.IncorporationType;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;

public record UpdateProfileRequest(
    @NotBlank(message = "Company name in English is required")
    String companyName,
    String companyNameNepali,
    String legalName,
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
    String phone,
    String email,
    IncorporationType incorporationType,
    BusinessNature businessNature,
    String authorizedPersonName,
    String authorizedPersonDesignation,
    String authorizedPersonPhone,
    String authorizedPersonEmail,
    Integer setupStep
) {}

