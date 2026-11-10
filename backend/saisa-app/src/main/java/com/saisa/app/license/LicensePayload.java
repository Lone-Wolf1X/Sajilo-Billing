package com.saisa.app.license;

import java.time.Instant;
import java.util.List;

public record LicensePayload(
    String licenseId,
    String tenantCode,
    String companyName,
    String panNumber,
    LicensePlan plan,
    Instant issuedAt,
    Instant expiresAt,
    int maxUsers,
    List<String> allowedFeatures
) {}
