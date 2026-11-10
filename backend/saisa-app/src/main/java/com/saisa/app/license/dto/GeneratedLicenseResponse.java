package com.saisa.app.license.dto;

import com.saisa.app.license.LicenseContainer;

public record GeneratedLicenseResponse(
        LicenseContainer container,
        String zipBase64,
        String filename,
        String passwordUsed,
        boolean emailed
) {}

