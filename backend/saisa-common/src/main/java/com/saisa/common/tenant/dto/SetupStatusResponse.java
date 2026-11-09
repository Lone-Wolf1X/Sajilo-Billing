package com.saisa.common.tenant.dto;

import com.saisa.common.tenant.Tenant;
import java.time.Instant;

public record SetupStatusResponse(
    Long tenantId,
    String tenantCode,
    String companyName,
    boolean setupCompleted,
    Instant setupCompletedAt,
    int setupStep
) {
    public static SetupStatusResponse from(Tenant t) {
        return new SetupStatusResponse(
            t.getId(),
            t.getTenantCode(),
            t.getCompanyName(),
            t.isSetupCompleted(),
            t.getSetupCompletedAt(),
            t.getSetupStep()
        );
    }
}

