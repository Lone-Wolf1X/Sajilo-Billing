-- =====================================================================
-- V3: Journal Entries (Header)
-- A journal entry is an immutable record of a financial event.
-- Posted entries are NEVER updated or deleted.
-- Corrections happen via reversing entries that reference the original.
-- =====================================================================

CREATE TABLE journal_entries (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    entry_number        VARCHAR(64)     NOT NULL,
    entry_date          DATE            NOT NULL,
    period_id           BIGINT          NOT NULL,
    entry_type          VARCHAR(32)     NOT NULL,
    status              VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
    description         TEXT,
    reference_type      VARCHAR(32),    -- e.g., 'SALES_INVOICE', 'PURCHASE_INVOICE', 'MANUAL'
    reference_id        BIGINT,         -- e.g., invoice ID
    reversal_of_id      BIGINT,         -- if this entry reverses another
    posted_at           TIMESTAMPTZ,
    posted_by           BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,

    CONSTRAINT fk_je_period FOREIGN KEY (period_id)
        REFERENCES accounting_periods(id),
    CONSTRAINT fk_je_reversal FOREIGN KEY (reversal_of_id)
        REFERENCES journal_entries(id),

    -- Unique entry number per tenant. Two companies can both have "JE-001".
    CONSTRAINT uq_je_tenant_number UNIQUE (tenant_id, entry_number),

    -- Idempotency key must be unique per tenant to prevent duplicate postings.
    CONSTRAINT uq_je_tenant_idempotency UNIQUE (tenant_id, idempotency_key),

    CONSTRAINT chk_je_type CHECK (
        entry_type IN ('MANUAL', 'SALES', 'PURCHASE', 'RECEIPT', 'PAYMENT',
                       'CONTRA', 'JOURNAL', 'OPENING', 'REVERSAL', 'ADJUSTMENT')
    ),
    CONSTRAINT chk_je_status CHECK (
        status IN ('DRAFT', 'POSTED', 'REVERSED')
    ),
    -- POSTED entries MUST have posted_at and posted_by.
    -- DRAFT entries MUST NOT have posted_at.
    CONSTRAINT chk_je_posted_consistency CHECK (
        (status = 'DRAFT' AND posted_at IS NULL AND posted_by IS NULL)
        OR (status IN ('POSTED', 'REVERSED') AND posted_at IS NOT NULL AND posted_by IS NOT NULL)
    ),
    -- A reversal entry MUST reference an original.
    -- (Conversely, an original CAN be reversed by many later entries.)
    CONSTRAINT chk_je_reversal_has_original CHECK (
        entry_type <> 'REVERSAL' OR reversal_of_id IS NOT NULL
    )
);

CREATE INDEX idx_je_tenant_date ON journal_entries(tenant_id, entry_date);
CREATE INDEX idx_je_tenant_status ON journal_entries(tenant_id, status);
CREATE INDEX idx_je_tenant_period ON journal_entries(tenant_id, period_id);
CREATE INDEX idx_je_reference ON journal_entries(tenant_id, reference_type, reference_id);
CREATE INDEX idx_je_reversal ON journal_entries(reversal_of_id) WHERE reversal_of_id IS NOT NULL;

COMMENT ON TABLE journal_entries IS
    'Immutable financial events. Once status = POSTED, this row cannot be modified or deleted.';
COMMENT ON COLUMN journal_entries.idempotency_key IS
    'Client-provided key. Duplicate POSTs with same key return the original result.';
COMMENT ON COLUMN journal_entries.reversal_of_id IS
    'For REVERSAL-type entries, points to the original entry being corrected.';
