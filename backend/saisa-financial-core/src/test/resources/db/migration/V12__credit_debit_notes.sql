-- =====================================================================
-- V12: Credit Notes (Sales Return) & Debit Notes (Purchase Return)
-- Both reduce the corresponding AR/AP and reverse GST proportionally.
-- =====================================================================

CREATE TABLE credit_notes (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    credit_note_number  VARCHAR(64)     NOT NULL,
    credit_note_date    DATE            NOT NULL,
    customer_id         BIGINT          NOT NULL,
    original_invoice_id BIGINT,          -- nullable: standalone credit note
    reason              TEXT,
    status              VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
    subtotal            NUMERIC(20,4)   NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,4)   NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,4)   NOT NULL DEFAULT 0,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'INR',
    journal_entry_id    BIGINT,
    posted_at           TIMESTAMPTZ,
    posted_by           BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_cn_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_cn_invoice FOREIGN KEY (original_invoice_id) REFERENCES sales_invoices(id),
    CONSTRAINT uq_cn_tenant_number UNIQUE (tenant_id, credit_note_number),
    CONSTRAINT uq_cn_tenant_idem UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT chk_cn_status CHECK (status IN ('DRAFT', 'POSTED', 'CANCELLED'))
);

CREATE TABLE credit_note_lines (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    credit_note_id      BIGINT          NOT NULL,
    line_number         INT             NOT NULL,
    item_id             BIGINT,
    description         TEXT,
    quantity            NUMERIC(20,4)   NOT NULL,
    unit_price          NUMERIC(20,4)   NOT NULL,
    tax_rate            NUMERIC(5,4)    NOT NULL DEFAULT 0,
    line_subtotal       NUMERIC(20,4)   NOT NULL,
    line_tax            NUMERIC(20,4)   NOT NULL,
    line_total          NUMERIC(20,4)   NOT NULL,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_cnl_cn FOREIGN KEY (credit_note_id) REFERENCES credit_notes(id) ON DELETE CASCADE,
    CONSTRAINT fk_cnl_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT uq_cnl_number UNIQUE (credit_note_id, line_number),
    CONSTRAINT chk_cnl_amounts CHECK (quantity > 0 AND unit_price >= 0 AND line_total >= 0)
);

CREATE TABLE debit_notes (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    debit_note_number   VARCHAR(64)     NOT NULL,
    debit_note_date     DATE            NOT NULL,
    vendor_id           BIGINT          NOT NULL,
    original_invoice_id BIGINT,
    reason              TEXT,
    status              VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
    subtotal            NUMERIC(20,4)   NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,4)   NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,4)   NOT NULL DEFAULT 0,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'INR',
    journal_entry_id    BIGINT,
    posted_at           TIMESTAMPTZ,
    posted_by           BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_dn_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(id),
    CONSTRAINT fk_dn_invoice FOREIGN KEY (original_invoice_id) REFERENCES purchase_invoices(id),
    CONSTRAINT uq_dn_tenant_number UNIQUE (tenant_id, debit_note_number),
    CONSTRAINT uq_dn_tenant_idem UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT chk_dn_status CHECK (status IN ('DRAFT', 'POSTED', 'CANCELLED'))
);

CREATE TABLE debit_note_lines (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    debit_note_id       BIGINT          NOT NULL,
    line_number         INT             NOT NULL,
    item_id             BIGINT,
    description         TEXT,
    quantity            NUMERIC(20,4)   NOT NULL,
    unit_price          NUMERIC(20,4)   NOT NULL,
    tax_rate            NUMERIC(5,4)    NOT NULL DEFAULT 0,
    line_subtotal       NUMERIC(20,4)   NOT NULL,
    line_tax            NUMERIC(20,4)   NOT NULL,
    line_total          NUMERIC(20,4)   NOT NULL,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_dnl_dn FOREIGN KEY (debit_note_id) REFERENCES debit_notes(id) ON DELETE CASCADE,
    CONSTRAINT fk_dnl_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT uq_dnl_number UNIQUE (debit_note_id, line_number),
    CONSTRAINT chk_dnl_amounts CHECK (quantity > 0 AND unit_price >= 0 AND line_total >= 0)
);

CREATE INDEX idx_cn_tenant_date ON credit_notes(tenant_id, credit_note_date);
CREATE INDEX idx_cn_customer ON credit_notes(tenant_id, customer_id);
CREATE INDEX idx_cn_invoice ON credit_notes(original_invoice_id) WHERE original_invoice_id IS NOT NULL;
CREATE INDEX idx_cnl_cn ON credit_note_lines(credit_note_id);

CREATE INDEX idx_dn_tenant_date ON debit_notes(tenant_id, debit_note_date);
CREATE INDEX idx_dn_vendor ON debit_notes(tenant_id, vendor_id);
CREATE INDEX idx_dn_invoice ON debit_notes(original_invoice_id) WHERE original_invoice_id IS NOT NULL;
CREATE INDEX idx_dnl_dn ON debit_note_lines(debit_note_id);

-- Invoice-level credit tracking (parallel to amount_paid)
ALTER TABLE sales_invoices
    ADD COLUMN amount_credited NUMERIC(20,4) NOT NULL DEFAULT 0,
    ADD CONSTRAINT chk_si_credited CHECK (
        amount_credited >= 0 AND amount_paid + amount_credited <= total_amount
    );

ALTER TABLE purchase_invoices
    ADD COLUMN amount_credited NUMERIC(20,4) NOT NULL DEFAULT 0,
    ADD CONSTRAINT chk_pi_credited CHECK (
        amount_credited >= 0 AND amount_paid + amount_credited <= total_amount
    );
