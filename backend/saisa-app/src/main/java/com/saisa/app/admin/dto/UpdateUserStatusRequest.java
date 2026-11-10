package com.saisa.app.admin.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateUserStatusRequest(
    @NotBlank String status   // ACTIVE or DISABLED
) {}

