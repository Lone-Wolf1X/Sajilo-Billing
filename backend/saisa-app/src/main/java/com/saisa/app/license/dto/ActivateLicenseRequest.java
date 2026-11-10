package com.saisa.app.license.dto;

public record ActivateLicenseRequest(
        String zipBase64,
        String zipPassword,
        String licenseJson
) {}
