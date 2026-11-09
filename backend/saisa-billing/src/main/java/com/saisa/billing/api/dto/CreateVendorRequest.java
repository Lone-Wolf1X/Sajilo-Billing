package com.saisa.billing.api.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateVendorRequest(
    @NotBlank String vendorCode,
    @NotBlank String vendorName,
    String gstin,
    String pan,
    String email,
    String phone,
    String billingAddress,
    String state
) {}

