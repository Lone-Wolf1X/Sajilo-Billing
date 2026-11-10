package com.saisa.app.admin.dto;

import java.time.Instant;

public record TenantSummaryResponse(
    Long id,
    String tenantCode,
    String companyName,
    String companyNameNepali,
    String panVatNo,
    String email,
    String phone,
    String status,
    boolean setupCompleted,
    Instant createdAt,
    long userCount,
    long invoiceCount
) {}

