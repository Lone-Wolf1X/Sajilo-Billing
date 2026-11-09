package com.saisa.billing.api.dto;

import com.saisa.billing.domain.invoice.Customer;

public record CustomerResponse(
    Long id,
    String customerCode,
    String customerName,
    String gstin,
    String pan,
    String email,
    String phone,
    String billingAddress,
    String state,
    boolean active
) {
    public static CustomerResponse from(Customer c) {
        return new CustomerResponse(
            c.getId(),
            c.getCustomerCode(),
            c.getCustomerName(),
            c.getGstin(),
            c.getPan(),
            c.getEmail(),
            c.getPhone(),
            c.getBillingAddress(),
            c.getState(),
            c.isActive()
        );
    }
}

