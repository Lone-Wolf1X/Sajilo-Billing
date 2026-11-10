package com.saisa.app.platform.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record PublicDemoRequest(
    @NotBlank @Size(max = 255) String fullName,
    @NotBlank @Email String email,
    @NotBlank @Size(max = 50) String phone,
    @NotBlank @Size(max = 255) String companyName,
    String city,
    String notes
) {}

