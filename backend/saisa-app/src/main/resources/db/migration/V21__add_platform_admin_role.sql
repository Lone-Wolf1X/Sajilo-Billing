-- =====================================================================
-- V21: PLATFORM_ADMIN role + _platform tenant + superadmin user
--
-- Design:
--   - PLATFORM_ADMIN is the SAISA Pro team (you) — manages all tenants
--   - _platform is a special "system tenant" that owns the superadmin user
--   - _platform tenant has NO business data (no accounts, no invoices)
--   - Its ONLY purpose is to hold PLATFORM_ADMIN users
--
-- Password for superadmin:
--   Will be seeded by Java code at startup (see PlatformSeeder.java).
--   Default dev password: ChangeMe#2026 (MUST change in production)
--
-- Idempotent: safe to run on existing databases.
-- =====================================================================

-- 1. Add PLATFORM_ADMIN role
INSERT INTO roles (role_code, role_name, description)
VALUES ('PLATFORM_ADMIN', 'Platform Administrator',
        'SAISA Pro team — manages all tenants, licenses, and system settings')
ON CONFLICT (role_code) DO NOTHING;

-- 2. Create _platform tenant (system tenant)
-- Uses ON CONFLICT so re-running migration is safe.
INSERT INTO tenants (
    tenant_code,
    company_name,
    legal_name,
    country,
    status,
    fiscal_year_start_month,
    setup_completed,
    setup_step,
    version,
    created_at,
    updated_at
)
VALUES (
    '_platform',
    'SAISA Pro — Platform',
    'NextGen Innovations Pvt Ltd',
    'Nepal',
    'ACTIVE',
    4,
    TRUE,
    3,
    0,
    NOW(),
    NOW()
)
ON CONFLICT (tenant_code) DO NOTHING;

-- 3. Create superadmin user in _platform tenant
-- Password hash will be replaced by PlatformSeeder.java at startup.
-- Here we insert with a placeholder that will never match a real password
-- (so login fails until Java seeder runs).
INSERT INTO users (
    tenant_id,
    username,
    email,
    password_hash,
    full_name,
    status,
    failed_login_attempts,
    version,
    created_at,
    updated_at
)
SELECT
    t.id,
    'superadmin',
    'superadmin@nextgeninnovations.com.np',
    '$2a$12$PLACEHOLDER_PLACEHOLDER_PLACEHOLDER_PLACEHOLDER_PLACEHOLDER',
    'SAISA Pro Super Admin',
    'ACTIVE',
    0,
    0,
    NOW(),
    NOW()
FROM tenants t
WHERE t.tenant_code = '_platform'
ON CONFLICT (tenant_id, username) DO NOTHING;

-- 4. Link superadmin → PLATFORM_ADMIN role
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u
CROSS JOIN roles r
WHERE u.username = 'superadmin'
  AND r.role_code = 'PLATFORM_ADMIN'
ON CONFLICT DO NOTHING;

