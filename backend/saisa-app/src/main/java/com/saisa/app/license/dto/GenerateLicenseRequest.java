package com.saisa.app.license.dto;

import com.saisa.app.license.LicensePlan;
import jakarta.validation.constraints.NotBlank;
import java.util.List;

public record GenerateLicenseRequest(
        @NotBlank String tenantCode,
        @NotBlank String companyName,
        String panNumber,
        LicensePlan plan,
        int durationDays,
        int maxUsers,
        List<String> allowedFeatures,
        @NotBlank String zipPassword,
        String deliveryEmail
) {}
