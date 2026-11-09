-- =====================================================================
-- V13: Bank Reconciliation
-- Bank statement lines mirror the bank's view of the account.
-- Adjustments are journal entries for items NOT already in our books
-- (bank charges, interest, corrections).
-- =====================================================================

CREATE TABLE bank_statement_lines (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    bank_account_id     BIGINT          NOT NULL,
    statement_date      DATE            NOT NULL,
    description         TEXT,
    reference_no        VARCHAR(128),
    debit_amount        NUMERIC(20,4)   NOT NULL DEFAULT 0,  -- money OUT of our account per bank
    credit_amount       NUMERIC(20,4)   NOT NULL DEFAULT 0,  -- money IN to our account per bank
    running_balance     NUMERIC(20,4),
    status              VARCHAR(16)     NOT NULL DEFAULT 'UNMATCHED',
    matched_payment_id  BIGINT,
    matched_at          TIMESTAMPTZ,
    matched_by          BIGINT,
    notes               TEXT,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,

    CONSTRAINT fk_bsl_bank FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(id),
    CONSTRAINT chk_bsl_status CHECK (status IN ('UNMATCHED', 'MATCHED', 'IGNORED')),
    CONSTRAINT chk_bsl_one_side CHECK (
        (debit_amount > 0 AND credit_amount = 0) OR
        (debit_amount = 0 AND credit_amount > 0)
    ),
    CONSTRAINT chk_bsl_matched_consistency CHECK (
        (status = 'MATCHED' AND matched_payment_id IS NOT NULL AND matched_at IS NOT NULL)
        OR (status <> 'MATCHED' AND matched_payment_id IS NULL AND matched_at IS NULL)
    )
);

CREATE TABLE bank_adjustments (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    bank_account_id     BIGINT          NOT NULL,
    adjustment_date     DATE            NOT NULL,
    adjustment_type     VARCHAR(32)     NOT NULL,
    amount              NUMERIC(20,4)   NOT NULL,
    description         TEXT,
    journal_entry_id    BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,

    CONSTRAINT fk_adj_bank FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(id),
    CONSTRAINT uq_adj_tenant_idem UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT chk_adj_type CHECK (adjustment_type IN
        ('BANK_CHARGE', 'INTEREST_CREDIT', 'CORRECTION_IN', 'CORRECTION_OUT')),
    CONSTRAINT chk_adj_amount_positive CHECK (amount > 0)
);

CREATE INDEX idx_bsl_tenant_bank_date ON bank_statement_lines(tenant_id, bank_account_id, statement_date);
CREATE INDEX idx_bsl_status ON bank_statement_lines(tenant_id, status);
CREATE INDEX idx_bsl_payment ON bank_statement_lines(matched_payment_id) WHERE matched_payment_id IS NOT NULL;

CREATE INDEX idx_adj_tenant_bank_date ON bank_adjustments(tenant_id, bank_account_id, adjustment_date);
