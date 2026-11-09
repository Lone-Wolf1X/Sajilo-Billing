package com.saisa.billing.api.dto;

import com.saisa.billing.domain.invoice.Vendor;

public record VendorResponse(
    Long id,
    String vendorCode,
    String vendorName,
    String gstin,
    String pan,
    String email,
    String phone,
    String billingAddress,
    String state,
    boolean active
) {
    public static VendorResponse from(Vendor v) {
        return new VendorResponse(
            v.getId(),
            v.getVendorCode(),
            v.getVendorName(),
            v.getGstin(),
            v.getPan(),
            v.getEmail(),
            v.getPhone(),
            v.getBillingAddress(),
            v.getState(),
            v.isActive()
        );
    }
}

