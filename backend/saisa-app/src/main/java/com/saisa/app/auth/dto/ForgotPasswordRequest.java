package com.saisa.app.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record ForgotPasswordRequest(
    @NotBlank(message = "इमेल अनिवार्य छ")
    @Email(message = "मान्य इमेल ठेगाना प्रविष्ट गर्नुहोस्")
    String email,

    String tenantCode
) {}

