package com.saisa.common.audit;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.common.tenant.TenantContext;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Service
public class AuditLogService {

    private static final Logger log = LoggerFactory.getLogger(AuditLogService.class);

    private final AuditLogRepository repo;
    private final ObjectMapper objectMapper;

    public AuditLogService(AuditLogRepository repo, ObjectMapper objectMapper) {
        this.repo = repo;
        this.objectMapper = objectMapper;
    }

    /**
     * Record an audit event. Uses REQUIRES_NEW so that failures in the
     * caller do NOT roll back the audit record - attackers who fail
     * login attempts must still be logged.
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void record(String action, String entityType, Long entityId,
                       String outcome, Object details, Long durationMs) {
        AuditLog a = new AuditLog();
        a.setTenantId(TenantContext.getOptionalTenantId().orElse(null));
        a.setUserId(TenantContext.getOptionalUserId().orElse(null));
        a.setAction(action);
        a.setEntityType(entityType);
        a.setEntityId(entityId);
        a.setOutcome(outcome);
        a.setDetails(serialize(details));
        a.setDurationMs(durationMs);
        a.setCorrelationId(MDC.get("correlationId"));

        HttpServletRequest req = currentRequest();
        if (req != null) {
            a.setIpAddress(clientIp(req));
            a.setUserAgent(truncate(req.getHeader("User-Agent"), 512));
        }

        try {
            repo.save(a);
        } catch (Exception e) {
            // Never let an audit failure crash the caller.
            log.error("Failed to record audit log for action={}", action, e);
        }
    }

    public void success(String action, String entityType, Long entityId, Object details) {
        record(action, entityType, entityId, "SUCCESS", details, null);
    }

    public void failure(String action, String entityType, Long entityId, Object details) {
        record(action, entityType, entityId, "FAILURE", details, null);
    }

    private String serialize(Object o) {
        if (o == null) return null;
        try {
            return objectMapper.writeValueAsString(o);
        } catch (Exception e) {
            return "{\"serializationError\":\"" + e.getMessage() + "\"}";
        }
    }

    private HttpServletRequest currentRequest() {
        var attrs = RequestContextHolder.getRequestAttributes();
        if (attrs instanceof ServletRequestAttributes sra) {
            return sra.getRequest();
        }
        return null;
    }

    private String clientIp(HttpServletRequest req) {
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) {
            return xff.split(",")[0].trim();
        }
        return req.getRemoteAddr();
    }

    private String truncate(String s, int max) {
        if (s == null) return null;
        return s.length() > max ? s.substring(0, max) : s;
    }
}
