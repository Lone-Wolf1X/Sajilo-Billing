package com.saisa.app.audit;

import com.saisa.common.audit.AuditLogService;
import com.saisa.common.audit.Auditable;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class AuditAspect {

    private final AuditLogService auditService;

    public AuditAspect(AuditLogService auditService) {
        this.auditService = auditService;
    }

    @Around("@annotation(auditable)")
    public Object audit(ProceedingJoinPoint pjp, Auditable auditable) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            Object result = pjp.proceed();
            long dur = System.currentTimeMillis() - start;
            auditService.record(auditable.action(), auditable.entityType(),
                null, "SUCCESS", null, dur);
            return result;
        } catch (Throwable t) {
            long dur = System.currentTimeMillis() - start;
            auditService.record(auditable.action(), auditable.entityType(),
                null, "FAILURE",
                java.util.Map.of("error", t.getClass().getSimpleName(),
                                 "message", String.valueOf(t.getMessage())),
                dur);
            throw t;
        }
    }
}
