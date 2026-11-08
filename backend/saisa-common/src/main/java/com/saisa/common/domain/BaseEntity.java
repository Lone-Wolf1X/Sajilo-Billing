package com.saisa.common.domain;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Version;
import java.time.Instant;
import lombok.Getter;
import lombok.Setter;

/**
 * Base class for all persistent entities.
 *
 * Provides:
 * - Primary key (BIGSERIAL)
 * - Optimistic locking version (JPA @Version)
 * - Audit timestamps (createdAt, updatedAt)
 * - Audit user IDs (createdBy, updatedBy) - populated by JPA auditing
 *
 * We deliberately use {@link Instant} instead of LocalDateTime because
 * financial audit logs MUST be timezone-safe. The database stores TIMESTAMPTZ;
 * Instant maps cleanly to that.
 */
@MappedSuperclass
@Getter
@Setter
public abstract class BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Optimistic locking. JPA will add this to the WHERE clause of every UPDATE
     * and throw OptimisticLockException if another transaction updated the row.
     * Essential for concurrent financial postings.
     */
    @Version
    @Column(nullable = false)
    private Long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @Column(name = "updated_by")
    private Long updatedBy;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = Instant.now();
        }
        if (updatedAt == null) {
            updatedAt = Instant.now();
        }
        if (version == null) {
            version = 0L;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
    }
}

