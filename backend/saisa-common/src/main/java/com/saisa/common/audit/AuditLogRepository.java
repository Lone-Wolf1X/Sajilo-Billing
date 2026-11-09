package com.saisa.common.audit;

import java.time.Instant;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    List<AuditLog> findTop100ByTenantIdOrderByCreatedAtDesc(Long tenantId);

    List<AuditLog> findTop100ByTenantIdAndUserIdOrderByCreatedAtDesc(Long tenantId, Long userId);

    List<AuditLog> findTop100ByTenantIdAndActionOrderByCreatedAtDesc(Long tenantId, String action);

    List<AuditLog> findTop100ByTenantIdAndCreatedAtBetweenOrderByCreatedAtDesc(
        Long tenantId, Instant from, Instant to);
}
