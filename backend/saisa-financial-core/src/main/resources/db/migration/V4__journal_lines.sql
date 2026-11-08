-- =====================================================================
-- V4: Journal Lines
-- Each line is either a DEBIT or a CREDIT to a specific account.
-- Double-entry rule: sum(debits) = sum(credits) for every entry.
-- =====================================================================

CREATE TABLE journal_lines (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    journal_entry_id    BIGINT          NOT NULL,
    line_number         INT             NOT NULL,
    account_id          BIGINT          NOT NULL,
    debit_amount        NUMERIC(20, 4)  NOT NULL DEFAULT 0,
    credit_amount       NUMERIC(20, 4)  NOT NULL DEFAULT 0,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'INR',
    description         TEXT,

    CONSTRAINT fk_jl_entry FOREIGN KEY (journal_entry_id)
        REFERENCES journal_entries(id) ON DELETE RESTRICT,
    CONSTRAINT fk_jl_account FOREIGN KEY (account_id)
        REFERENCES chart_of_accounts(id),

    CONSTRAINT uq_jl_entry_line UNIQUE (journal_entry_id, line_number),

    -- An amount MUST be non-negative.
    CONSTRAINT chk_jl_amounts_non_negative CHECK (
        debit_amount >= 0 AND credit_amount >= 0
    ),

    -- EXACTLY ONE of debit or credit must be > 0. Never both, never neither.
    -- This is the single most important constraint in the entire schema.
    CONSTRAINT chk_jl_one_side_only CHECK (
        (debit_amount > 0 AND credit_amount = 0)
        OR (debit_amount = 0 AND credit_amount > 0)
    )
);

CREATE INDEX idx_jl_entry ON journal_lines(journal_entry_id);
CREATE INDEX idx_jl_tenant_account ON journal_lines(tenant_id, account_id);
CREATE INDEX idx_jl_tenant_entry ON journal_lines(tenant_id, journal_entry_id);

COMMENT ON TABLE journal_lines IS
    'Debit/Credit lines of a journal entry. A line is exclusively debit OR credit, never both.';
COMMENT ON COLUMN journal_lines.debit_amount IS
    'NUMERIC(20,4) - exact decimal. NEVER use floating point for money.';
