package com.saisa.app.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ResetPasswordWithOtpRequest(
    @NotBlank(message = "इमेल अनिवार्य छ")
    @Email(message = "मान्य इमेल ठेगाना प्रविष्ट गर्नुहोस्")
    String email,

    @NotBlank(message = "OTP कोड अनिवार्य छ")
    @Size(min = 6, max = 6, message = "OTP ६ अङ्कको हुनुपर्दछ")
    String otp,

    @NotBlank(message = "नयाँ पासवर्ड अनिवार्य छ")
    @Size(min = 6, max = 100, message = "पासवर्ड कम्तिमा ६ वर्णको हुनुपर्दछ")
    String newPassword
) {}

