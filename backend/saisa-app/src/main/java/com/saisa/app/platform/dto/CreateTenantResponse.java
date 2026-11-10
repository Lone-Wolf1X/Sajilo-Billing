package com.saisa.app.platform.dto;

public record CreateTenantResponse(
    Long tenantId,
    String tenantCode,
    String companyName,
    String adminUsername,
    String adminEmail,
    String generatedPassword,
    boolean passwordWasGenerated
) {}

