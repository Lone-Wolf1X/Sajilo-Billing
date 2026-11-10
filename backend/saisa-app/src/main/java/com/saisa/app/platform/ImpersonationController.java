package com.saisa.app.platform;

import com.saisa.app.security.JwtService;
import com.saisa.common.audit.AuditLogService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantContext;
import com.saisa.common.tenant.TenantRepository;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/platform")
@PreAuthorize("hasRole('PLATFORM_ADMIN')")
public class ImpersonationController {

    private final TenantRepository tenantRepo;
    private final JwtService jwtService;
    private final AuditLogService auditLog;

    public ImpersonationController(TenantRepository tenantRepo,
                                   JwtService jwtService,
                                   AuditLogService auditLog) {
        this.tenantRepo = tenantRepo;
        this.jwtService = jwtService;
        this.auditLog = auditLog;
    }

    public record ImpersonationResponse(
        String accessToken,
        String tokenType,
        String impersonatingTenantCode,
        Long targetTenantId,
        String companyName
    ) {}

    @PostMapping("/impersonate/{tenantCode}")
    public ResponseEntity<ImpersonationResponse> impersonate(@PathVariable String tenantCode) {
        Tenant targetTenant = tenantRepo.findByTenantCode(tenantCode)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Target tenant not found: " + tenantCode));

        Long adminUserId = TenantContext.getCurrentUserId();
        Long originalTenantId = TenantContext.getOriginalTenantId();

        String token = jwtService.generateImpersonationToken(
            adminUserId,
            originalTenantId,
            targetTenant.getId(),
            targetTenant.getTenantCode(),
            List.of("PLATFORM_ADMIN")
        );

        auditLog.record("IMPERSONATE_TENANT", "Tenant", targetTenant.getId(), "SUCCESS",
            Map.of("targetTenantCode", targetTenant.getTenantCode(), "adminUserId", adminUserId), 0L);

        return ResponseEntity.ok(new ImpersonationResponse(
            token,
            "Bearer",
            targetTenant.getTenantCode(),
            targetTenant.getId(),
            targetTenant.getCompanyName()
        ));
    }
}

