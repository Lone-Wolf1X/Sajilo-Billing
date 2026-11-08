-- =====================================================================
-- V1: Chart of Accounts
-- The foundation of double-entry accounting.
-- Every account belongs to exactly one tenant (company).
-- =====================================================================

CREATE TABLE chart_of_accounts (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    account_code        VARCHAR(32)     NOT NULL,
    account_name        VARCHAR(255)    NOT NULL,
    account_type        VARCHAR(32)     NOT NULL,
    parent_account_id   BIGINT,
    is_system_account   BOOLEAN         NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_by          BIGINT,

    CONSTRAINT fk_coa_parent FOREIGN KEY (parent_account_id)
        REFERENCES chart_of_accounts(id),

    CONSTRAINT uq_coa_tenant_code UNIQUE (tenant_id, account_code),

    -- Account type must be one of the 5 fundamental types.
    -- These 5 types map directly to the P&L and Balance Sheet structure.
    CONSTRAINT chk_coa_account_type CHECK (
        account_type IN ('ASSET', 'LIABILITY', 'EQUITY', 'INCOME', 'EXPENSE')
    ),

    -- A parent account cannot be a system account AND cannot be itself.
    CONSTRAINT chk_coa_no_self_parent CHECK (parent_account_id IS NULL OR parent_account_id <> id)
);

CREATE INDEX idx_coa_tenant ON chart_of_accounts(tenant_id);
CREATE INDEX idx_coa_tenant_type ON chart_of_accounts(tenant_id, account_type);
CREATE INDEX idx_coa_parent ON chart_of_accounts(parent_account_id);

COMMENT ON TABLE chart_of_accounts IS
    'The list of all accounts for each tenant. Every financial transaction posts to these accounts.';
COMMENT ON COLUMN chart_of_accounts.account_type IS
    'ASSET | LIABILITY | EQUITY | INCOME | EXPENSE. This drives the P&L and Balance Sheet.';
COMMENT ON COLUMN chart_of_accounts.is_system_account IS
    'TRUE for accounts auto-created by the system (e.g., AR, AP, GST Output). These cannot be deleted.';
