package com.saisa.app.api.common;

import com.saisa.common.tenant.TenantContext;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

/**
 * Central place to enforce tenant ownership.
 *
 * Every time a controller fetches an entity by ID, it MUST call
 * TenantGuard.ensureOwned(entity.getTenantId()). If the entity belongs
 * to a different tenant, this throws 404 (not 403) deliberately.
 *
 * WHY 404 and not 403:
 *   Returning 403 leaks the fact that the entity exists in another tenant.
 *   An attacker can enumerate IDs to learn about other companies.
 *   404 tells them "there is nothing here", which is safer.
 */
public final class TenantGuard {

    private TenantGuard() {}

    public static void ensureOwned(Long entityTenantId) {
        Long current = TenantContext.getCurrentTenantId();
        if (!current.equals(entityTenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found");
        }
    }
}
