-- =====================================================================
-- V2: Accounting Periods
-- Defines fiscal periods (months / years) and their open/closed state.
-- A closed period rejects new postings at the database level.
-- =====================================================================

CREATE TABLE accounting_periods (
    id              BIGSERIAL       PRIMARY KEY,
    tenant_id       BIGINT          NOT NULL,
    period_name     VARCHAR(64)     NOT NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    status          VARCHAR(16)     NOT NULL DEFAULT 'OPEN',
    closed_at       TIMESTAMPTZ,
    closed_by       BIGINT,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_ap_tenant_name UNIQUE (tenant_id, period_name),
    CONSTRAINT chk_ap_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_ap_status CHECK (status IN ('OPEN', 'CLOSED', 'LOCKED')),

    -- A CLOSED or LOCKED period MUST have a closed_at timestamp.
    CONSTRAINT chk_ap_closed_has_timestamp CHECK (
        (status = 'OPEN' AND closed_at IS NULL)
        OR (status IN ('CLOSED', 'LOCKED') AND closed_at IS NOT NULL)
    )
);

CREATE INDEX idx_ap_tenant_dates ON accounting_periods(tenant_id, start_date, end_date);
CREATE INDEX idx_ap_tenant_status ON accounting_periods(tenant_id, status);

COMMENT ON TABLE accounting_periods IS
    'Fiscal periods. Once CLOSED, no journal entry can be posted to a date within this period.';
COMMENT ON COLUMN accounting_periods.status IS
    'OPEN = accepting entries. CLOSED = no new entries, but reversals allowed. LOCKED = no changes at all (audit lock).';
