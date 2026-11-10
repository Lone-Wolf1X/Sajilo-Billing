package com.saisa.app.license;

import java.time.Instant;
import java.util.List;

public record LicenseStatusResponse(
        boolean active,
        boolean isTrial,
        String plan,
        String licenseId,
        String companyName,
        String panNumber,
        Instant issuedAt,
        Instant expiresAt,
        long daysRemaining,
        int maxUsers,
        List<String> allowedFeatures,
        boolean expired
) {}

