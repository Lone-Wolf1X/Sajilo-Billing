package com.saisa.app.platform;

import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.Role;
import com.saisa.common.user.RoleRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import java.time.Instant;
import java.util.HashSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Seeds the PLATFORM_ADMIN superadmin user at startup.
 *
 * Runs AFTER Flyway migration (V21) — so roles/tenants exist.
 *
 * Responsibilities:
 *   1. Ensure PLATFORM_ADMIN role exists
 *   2. Ensure _platform tenant exists
 *   3. Ensure superadmin user exists with correct password hash
 *   4. Ensure superadmin has PLATFORM_ADMIN role
 *
 * Idempotent: safe on every startup.
 * Skips if config.seedEnabled = false.
 */
@Component
public class PlatformSeeder implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(PlatformSeeder.class);

    private final PlatformProperties props;
    private final TenantRepository tenantRepo;
    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final PasswordEncoder passwordEncoder;

    public PlatformSeeder(
            PlatformProperties props,
            TenantRepository tenantRepo,
            UserRepository userRepo,
            RoleRepository roleRepo,
            PasswordEncoder passwordEncoder) {
        this.props = props;
        this.tenantRepo = tenantRepo;
        this.userRepo = userRepo;
        this.roleRepo = roleRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (!props.isSeedEnabled()) {
            log.info("Platform seeding disabled (saisa.platform.seed-enabled=false)");
            return;
        }

        // 1. Ensure PLATFORM_ADMIN role
        Role platformAdminRole = roleRepo.findByRoleCode("PLATFORM_ADMIN")
            .orElseGet(() -> {
                Role r = new Role();
                r.setRoleCode("PLATFORM_ADMIN");
                r.setRoleName("Platform Administrator");
                r.setDescription("SAISA Pro team — manages all tenants");
                log.warn("PLATFORM_ADMIN role missing — creating now");
                return roleRepo.save(r);
            });

        // 2. Ensure _platform tenant
        Tenant platformTenant = tenantRepo.findByTenantCode("_platform")
            .orElseGet(() -> {
                Tenant t = new Tenant();
                t.setTenantCode("_platform");
                t.setCompanyName("SAISA Pro — Platform");
                t.setLegalName("NextGen Innovations Pvt Ltd");
                t.setCountry("Nepal");
                t.setStatus("ACTIVE");
                t.setFiscalYearStartMonth(4);
                t.setSetupCompleted(true);
                t.setSetupStep(3);
                log.warn("_platform tenant missing — creating now");
                return tenantRepo.save(t);
            });

        // 3. Ensure superadmin user with fresh password
        User superadmin = userRepo
            .findByTenantIdAndUsername(platformTenant.getId(), props.getSuperadminUsername())
            .orElseGet(() -> {
                User u = new User();
                u.setTenantId(platformTenant.getId());
                u.setUsername(props.getSuperadminUsername());
                u.setEmail(props.getSuperadminEmail());
                u.setFullName(props.getSuperadminFullName());
                u.setStatus("ACTIVE");
                log.warn("superadmin user missing — creating now");
                return u;
            });

        boolean isNew = (superadmin.getId() == null);
        if (isNew || superadmin.getPasswordHash() == null) {
            superadmin.setPasswordHash(passwordEncoder.encode(props.getSuperadminPassword()));
        }
        superadmin.setEmail(props.getSuperadminEmail());
        superadmin.setFullName(props.getSuperadminFullName());
        superadmin.setFailedLoginAttempts(0);
        superadmin.setLockedUntil(null);
        superadmin.setUpdatedAt(Instant.now());
        if (superadmin.getRoles() == null) {
            superadmin.setRoles(new HashSet<>());
        }
        superadmin = userRepo.save(superadmin);

        // 4. Ensure role link
        boolean hasRole = superadmin.getRoles().stream()
            .anyMatch(r -> "PLATFORM_ADMIN".equals(r.getRoleCode()));
        if (!hasRole) {
            superadmin.getRoles().add(platformAdminRole);
            superadmin = userRepo.save(superadmin);
            log.warn("PLATFORM_ADMIN role attached to superadmin");
        }

        log.info("Platform seeder OK — superadmin user ready in _platform tenant (id={})",
            platformTenant.getId());
    }
}

