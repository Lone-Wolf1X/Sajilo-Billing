package com.saisa.app.platform.dto;

import java.time.Instant;

public record TenantSummaryResponse(
    Long id,
    String tenantCode,
    String companyName,
    String companyNameNepali,
    String status,
    boolean setupCompleted,
    int setupStep,
    long userCount,
    LicenseSummary license,
    Instant createdAt,
    Instant lastUpdatedAt
) {
    public record LicenseSummary(
        String licenseId,
        String plan,
        String status,
        Instant expiresAt,
        int maxUsers,
        long daysRemaining
    ) {}
}

