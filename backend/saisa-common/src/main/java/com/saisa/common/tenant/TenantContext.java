package com.saisa.common.tenant;

import java.util.Optional;

/**
 * Holds the current tenant ID for the executing thread.
 *
 * SECURITY CRITICAL:
 *   - Set by the JWT authentication filter at the start of each request
 *   - Cleared by the same filter in a finally block after request completion
 *   - MUST NOT be trusted from request parameters or headers
 *   - MUST be cleared even if the request throws an exception, otherwise
 *     ThreadPool reuse could leak tenant identity to the next request
 *
 * Using InheritableThreadLocal would allow child threads to inherit the
 * tenant, but we deliberately do NOT do that because:
 *   1. Async operations must be explicit about tenant propagation
 *   2. Silent inheritance is a security hazard
 *   3. Explicit propagation forces the developer to think
 */
public final class TenantContext {

    private static final ThreadLocal<Long> CURRENT_TENANT = new ThreadLocal<>();
    private static final ThreadLocal<Long> CURRENT_USER = new ThreadLocal<>();

    private TenantContext() {}

    public static void setCurrentTenantId(Long tenantId) {
        CURRENT_TENANT.set(tenantId);
    }

    public static Long getCurrentTenantId() {
        Long id = CURRENT_TENANT.get();
        if (id == null) {
            throw new IllegalStateException(
                "No tenant context set. This method must only be called inside an authenticated request.");
        }
        return id;
    }

    public static Optional<Long> getOptionalTenantId() {
        return Optional.ofNullable(CURRENT_TENANT.get());
    }

    public static void setCurrentUserId(Long userId) {
        CURRENT_USER.set(userId);
    }

    public static Long getCurrentUserId() {
        Long id = CURRENT_USER.get();
        if (id == null) {
            throw new IllegalStateException(
                "No user context set. This method must only be called inside an authenticated request.");
        }
        return id;
    }

    public static Optional<Long> getOptionalUserId() {
        return Optional.ofNullable(CURRENT_USER.get());
    }

    public static void clear() {
        CURRENT_TENANT.remove();
        CURRENT_USER.remove();
    }
}
