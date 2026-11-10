package com.saisa.app.audit;

import com.saisa.common.audit.AuditLog;
import com.saisa.common.audit.AuditLogRepository;
import com.saisa.common.tenant.TenantContext;
import java.time.Instant;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/audit-logs")
public class AuditLogController {

    private final AuditLogRepository repo;

    public AuditLogController(AuditLogRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT', 'VIEWER')")
    public List<AuditLog> list(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String action,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant from,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant to) {
        Long tenantId = TenantContext.getCurrentTenantId();

        if (from != null && to != null) {
            return repo.findTop100ByTenantIdAndCreatedAtBetweenOrderByCreatedAtDesc(
                tenantId, from, to);
        }
        if (userId != null) {
            return repo.findTop100ByTenantIdAndUserIdOrderByCreatedAtDesc(tenantId, userId);
        }
        if (action != null) {
            return repo.findTop100ByTenantIdAndActionOrderByCreatedAtDesc(tenantId, action);
        }
        return repo.findTop100ByTenantIdOrderByCreatedAtDesc(tenantId);
    }
}
