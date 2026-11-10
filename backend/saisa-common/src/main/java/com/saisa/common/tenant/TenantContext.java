package com.saisa.common.tenant;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * Holds the current tenant, user, and roles context for the executing thread.
 *
 * Supports cross-tenant impersonation:
 *   When a PLATFORM_ADMIN impersonates a target tenant, IMPERSONATED_TENANT is set.
 *   getCurrentTenantId() returns the impersonated tenant ID transparently,
 *   while getOriginalTenantId() retains the caller's actual system tenant ID.
 *
 * SECURITY CRITICAL:
 *   - Set by the JWT authentication filter at the start of each request
 *   - Cleared by the same filter in a finally block after request completion
 *   - MUST NOT be trusted from request parameters or headers
 *   - MUST be cleared even if the request throws an exception, otherwise
 *     ThreadPool reuse could leak tenant identity to the next request
 */
public final class TenantContext {

    private static final ThreadLocal<Long> CURRENT_TENANT = new ThreadLocal<>();
    private static final ThreadLocal<Long> CURRENT_USER = new ThreadLocal<>();
    private static final ThreadLocal<Long> IMPERSONATED_TENANT = new ThreadLocal<>();
    private static final ThreadLocal<String> IMPERSONATED_TENANT_CODE = new ThreadLocal<>();
    private static final ThreadLocal<List<String>> CURRENT_ROLES = new ThreadLocal<>();

    private TenantContext() {}

    public static void setCurrentTenantId(Long tenantId) {
        CURRENT_TENANT.set(tenantId);
    }

    /**
     * Returns the active tenant ID for data queries.
     * If PLATFORM_ADMIN is impersonating a tenant, returns the impersonated tenant ID.
     */
    public static Long getCurrentTenantId() {
        Long imp = IMPERSONATED_TENANT.get();
        if (imp != null) {
            return imp;
        }
        Long id = CURRENT_TENANT.get();
        if (id == null) {
            throw new IllegalStateException(
                "No tenant context set. This method must only be called inside an authenticated request.");
        }
        return id;
    }

    public static Optional<Long> getOptionalTenantId() {
        Long imp = IMPERSONATED_TENANT.get();
        if (imp != null) {
            return Optional.of(imp);
        }
        return Optional.ofNullable(CURRENT_TENANT.get());
    }

    /**
     * Returns the original tenant ID before any impersonation.
     */
    public static Long getOriginalTenantId() {
        return CURRENT_TENANT.get();
    }

    public static void setImpersonatedTenantId(Long tenantId) {
        IMPERSONATED_TENANT.set(tenantId);
    }

    public static Long getImpersonatedTenantId() {
        return IMPERSONATED_TENANT.get();
    }

    public static void setImpersonatedTenantCode(String tenantCode) {
        IMPERSONATED_TENANT_CODE.set(tenantCode);
    }

    public static String getImpersonatedTenantCode() {
        return IMPERSONATED_TENANT_CODE.get();
    }

    public static boolean isImpersonating() {
        return IMPERSONATED_TENANT.get() != null;
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

    public static void setCurrentRoles(List<String> roles) {
        if (roles == null) {
            CURRENT_ROLES.set(Collections.emptyList());
        } else {
            CURRENT_ROLES.set(List.copyOf(roles));
        }
    }

    public static List<String> getCurrentRoles() {
        List<String> roles = CURRENT_ROLES.get();
        return roles != null ? roles : Collections.emptyList();
    }

    public static boolean hasRole(String role) {
        if (role == null) return false;
        List<String> roles = CURRENT_ROLES.get();
        return roles != null && roles.contains(role);
    }

    public static boolean hasAnyRole(String... roles) {
        if (roles == null || roles.length == 0) return false;
        List<String> current = CURRENT_ROLES.get();
        if (current == null || current.isEmpty()) return false;
        for (String r : roles) {
            if (current.contains(r)) {
                return true;
            }
        }
        return false;
    }

    public static void clear() {
        CURRENT_TENANT.remove();
        CURRENT_USER.remove();
        IMPERSONATED_TENANT.remove();
        IMPERSONATED_TENANT_CODE.remove();
        CURRENT_ROLES.remove();
    }
}

