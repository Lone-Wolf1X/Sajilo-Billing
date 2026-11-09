package com.saisa.app.api.common;

import com.saisa.common.tenant.TenantContext;

/**
 * Helper to extract the current authenticated user info from TenantContext.
 *
 * Why not read from SecurityContext?
 *   - TenantContext is what the JWT filter sets (canonical, verified source).
 *   - We don't want controllers to accidentally read from a different source.
 *   - Centralizing here means a single place to audit.
 */
public final class AuthenticatedUser {

    private AuthenticatedUser() {}

    public static Long tenantId() {
        return TenantContext.getCurrentTenantId();
    }

    public static Long userId() {
        return TenantContext.getCurrentUserId();
    }
}
