package com.saisa.billing.api.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateCustomerRequest(
    @NotBlank String customerCode,
    @NotBlank String customerName,
    String gstin,
    String pan,
    String email,
    String phone,
    String billingAddress,
    String state
) {}

