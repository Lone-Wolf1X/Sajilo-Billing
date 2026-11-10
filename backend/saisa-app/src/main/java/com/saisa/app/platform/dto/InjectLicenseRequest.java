package com.saisa.app.platform.dto;

import jakarta.validation.constraints.NotBlank;
import java.util.List;

public record InjectLicenseRequest(
    @NotBlank String plan,
    Integer durationDays,
    Integer maxUsers,
    List<String> allowedFeatures,
    String deliveryEmail
) {}

