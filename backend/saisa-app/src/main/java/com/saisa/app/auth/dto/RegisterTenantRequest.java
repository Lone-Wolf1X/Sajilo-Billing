package com.saisa.app.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegisterTenantRequest(
    @NotBlank @Size(min = 3, max = 64) String tenantCode,
    @NotBlank String companyName,
    @NotBlank @Size(min = 3, max = 64) String username,
    @NotBlank @Email String email,
    @NotBlank @Size(min = 8, max = 128) String password,
    String fullName
) {}
