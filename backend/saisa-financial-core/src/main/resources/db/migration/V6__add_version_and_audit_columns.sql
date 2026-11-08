-- =====================================================================
-- V6: Optimistic Locking Version & Audit Columns
-- Aligns database tables with BaseEntity and enterprise audit requirements.
-- =====================================================================

-- 1. Chart of Accounts: add version
ALTER TABLE chart_of_accounts ADD COLUMN IF NOT EXISTS version BIGINT NOT NULL DEFAULT 0;

-- 2. Accounting Periods: add version and remaining audit columns
ALTER TABLE accounting_periods ADD COLUMN IF NOT EXISTS version BIGINT NOT NULL DEFAULT 0;
ALTER TABLE accounting_periods ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE accounting_periods ADD COLUMN IF NOT EXISTS created_by BIGINT;
ALTER TABLE accounting_periods ADD COLUMN IF NOT EXISTS updated_by BIGINT;

-- 3. Journal Entries: add version and update audit columns
ALTER TABLE journal_entries ADD COLUMN IF NOT EXISTS version BIGINT NOT NULL DEFAULT 0;
ALTER TABLE journal_entries ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE journal_entries ADD COLUMN IF NOT EXISTS updated_by BIGINT;

-- 4. Journal Lines: add version and audit columns
ALTER TABLE journal_lines ADD COLUMN IF NOT EXISTS version BIGINT NOT NULL DEFAULT 0;
ALTER TABLE journal_lines ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE journal_lines ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE journal_lines ADD COLUMN IF NOT EXISTS created_by BIGINT;
ALTER TABLE journal_lines ADD COLUMN IF NOT EXISTS updated_by BIGINT;

