-- =====================================================================
-- V17: Seed opening balance system accounts for existing tenants
-- New tenants get these via AuthService.seedSystemAccounts().
-- Existing tenants need backfill.
-- =====================================================================

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'FIXED_ASSETS', 'Fixed Assets', 'ASSET', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'FIXED_ASSETS');

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'INVESTMENTS', 'Investments', 'ASSET', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'INVESTMENTS');

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'OTHER_ASSETS', 'Other Assets', 'ASSET', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'OTHER_ASSETS');

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'BANK_LOANS', 'Bank Loans', 'LIABILITY', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'BANK_LOANS');

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'OTHER_LIABILITIES', 'Other Liabilities', 'LIABILITY', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'OTHER_LIABILITIES');

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'CAPITAL', 'Owner''s Capital', 'EQUITY', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'CAPITAL');

INSERT INTO chart_of_accounts
    (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT t.id, 'RETAINED_EARNINGS', 'Retained Earnings', 'EQUITY', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM chart_of_accounts c
    WHERE c.tenant_id = t.id AND c.account_code = 'RETAINED_EARNINGS');
