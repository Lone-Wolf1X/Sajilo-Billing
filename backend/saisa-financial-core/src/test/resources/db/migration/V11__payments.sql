-- =====================================================================
-- V11: Payments & Bank Accounts
-- Payments are business documents that reduce AR (customer payments) or
-- AP (vendor payments). Each payment generates a journal entry.
-- =====================================================================

CREATE TABLE bank_accounts (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    account_code        VARCHAR(64)     NOT NULL,
    account_name        VARCHAR(255)    NOT NULL,
    bank_name           VARCHAR(255),
    account_number      VARCHAR(64),
    ifsc_code           VARCHAR(16),
    gl_account_id       BIGINT          NOT NULL,
    is_default          BOOLEAN         NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_ba_gl FOREIGN KEY (gl_account_id) REFERENCES chart_of_accounts(id),
    CONSTRAINT uq_ba_tenant_code UNIQUE (tenant_id, account_code)
);

CREATE TABLE payments (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    payment_number      VARCHAR(64)     NOT NULL,
    payment_date        DATE            NOT NULL,
    amount              NUMERIC(20,4)   NOT NULL,
    unallocated_amount  NUMERIC(20,4)   NOT NULL DEFAULT 0,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'INR',
    party_type          VARCHAR(16)     NOT NULL,
    party_id            BIGINT          NOT NULL,
    payment_method      VARCHAR(16)     NOT NULL,
    bank_account_id     BIGINT,          -- required for BANK/CHEQUE/UPI/NEFT; null for CASH
    reference_no        VARCHAR(128),
    notes               TEXT,
    status              VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
    journal_entry_id    BIGINT,
    reversal_of_id      BIGINT,
    posted_at           TIMESTAMPTZ,
    posted_by           BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT uq_pay_tenant_number UNIQUE (tenant_id, payment_number),
    CONSTRAINT uq_pay_tenant_idem UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT chk_pay_party_type CHECK (party_type IN ('CUSTOMER', 'VENDOR')),
    CONSTRAINT chk_pay_method CHECK (payment_method IN
        ('CASH', 'BANK_TRANSFER', 'CHEQUE', 'UPI', 'NEFT', 'RTGS', 'IMPS', 'CARD')),
    CONSTRAINT chk_pay_status CHECK (status IN ('DRAFT', 'POSTED', 'REVERSED')),
    CONSTRAINT chk_pay_amount_positive CHECK (amount > 0),
    CONSTRAINT fk_pay_bank FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(id)
);

CREATE TABLE payment_allocations (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    payment_id          BIGINT          NOT NULL,
    invoice_type        VARCHAR(16)     NOT NULL,     -- SALES or PURCHASE
    invoice_id          BIGINT          NOT NULL,
    allocated_amount    NUMERIC(20,4)   NOT NULL,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_pa_payment FOREIGN KEY (payment_id)
        REFERENCES payments(id) ON DELETE CASCADE,
    CONSTRAINT chk_pa_type CHECK (invoice_type IN ('SALES', 'PURCHASE')),
    CONSTRAINT chk_pa_amount_positive CHECK (allocated_amount > 0)
);

CREATE INDEX idx_pay_tenant_date ON payments(tenant_id, payment_date);
CREATE INDEX idx_pay_tenant_party ON payments(tenant_id, party_type, party_id);
CREATE INDEX idx_pay_status ON payments(tenant_id, status);
CREATE INDEX idx_pa_payment ON payment_allocations(payment_id);
CREATE INDEX idx_pa_invoice ON payment_allocations(tenant_id, invoice_type, invoice_id);

-- Invoice sub-ledger field: amount_paid tracks total allocations per invoice.
ALTER TABLE sales_invoices
    ADD COLUMN amount_paid NUMERIC(20,4) NOT NULL DEFAULT 0,
    ADD CONSTRAINT chk_si_amount_paid CHECK (amount_paid >= 0 AND amount_paid <= total_amount);

ALTER TABLE purchase_invoices
    ADD COLUMN amount_paid NUMERIC(20,4) NOT NULL DEFAULT 0,
    ADD CONSTRAINT chk_pi_amount_paid CHECK (amount_paid >= 0 AND amount_paid <= total_amount);

