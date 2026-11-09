-- =====================================================================
-- V15: Seed Inventory Adjustment System Accounts
-- =====================================================================

INSERT INTO chart_of_accounts (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT id, 'INVENTORY_GAIN', 'Inventory Adjustment Gain', 'INCOME', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants
WHERE id NOT IN (SELECT tenant_id FROM chart_of_accounts WHERE account_code = 'INVENTORY_GAIN');

INSERT INTO chart_of_accounts (tenant_id, account_code, account_name, account_type, is_system_account, is_active, version, created_at, updated_at)
SELECT id, 'INVENTORY_LOSS', 'Inventory Adjustment Loss', 'EXPENSE', TRUE, TRUE, 0, NOW(), NOW()
FROM tenants
WHERE id NOT IN (SELECT tenant_id FROM chart_of_accounts WHERE account_code = 'INVENTORY_LOSS');
