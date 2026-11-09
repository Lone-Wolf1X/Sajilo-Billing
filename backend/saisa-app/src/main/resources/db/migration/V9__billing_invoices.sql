-- =====================================================================
-- V9: Billing - Sales & Purchase Invoices
-- Invoices are business documents. They are the SOURCE of journal
-- entries. Once an invoice is POSTED, its journal entry is immutable.
-- =====================================================================

-- Customers (buyers)
CREATE TABLE customers (
    id              BIGSERIAL       PRIMARY KEY,
    version         BIGINT          NOT NULL DEFAULT 0,
    tenant_id       BIGINT          NOT NULL,
    customer_code   VARCHAR(64)     NOT NULL,
    customer_name   VARCHAR(255)    NOT NULL,
    gstin           VARCHAR(15),
    pan             VARCHAR(10),
    email           VARCHAR(255),
    phone           VARCHAR(32),
    billing_address TEXT,
    state           VARCHAR(100),
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,

    CONSTRAINT uq_customers_tenant_code UNIQUE (tenant_id, customer_code)
);

-- Vendors (suppliers)
CREATE TABLE vendors (
    id              BIGSERIAL       PRIMARY KEY,
    version         BIGINT          NOT NULL DEFAULT 0,
    tenant_id       BIGINT          NOT NULL,
    vendor_code     VARCHAR(64)     NOT NULL,
    vendor_name     VARCHAR(255)    NOT NULL,
    gstin           VARCHAR(15),
    pan             VARCHAR(10),
    email           VARCHAR(255),
    phone           VARCHAR(32),
    billing_address TEXT,
    state           VARCHAR(100),
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,

    CONSTRAINT uq_vendors_tenant_code UNIQUE (tenant_id, vendor_code)
);

-- Sales Invoices
CREATE TABLE sales_invoices (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    invoice_number      VARCHAR(64)     NOT NULL,
    invoice_date        DATE            NOT NULL,
    due_date            DATE,
    customer_id         BIGINT          NOT NULL,
    status              VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
    subtotal            NUMERIC(20,4)   NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,4)   NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,4)   NOT NULL DEFAULT 0,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'INR',
    notes               TEXT,
    journal_entry_id    BIGINT,          -- set after auto-posting
    posted_at           TIMESTAMPTZ,
    posted_by           BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_si_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT uq_si_tenant_number UNIQUE (tenant_id, invoice_number),
    CONSTRAINT uq_si_tenant_idem UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT chk_si_status CHECK (status IN ('DRAFT', 'POSTED', 'CANCELLED')),
    CONSTRAINT chk_si_dates CHECK (due_date IS NULL OR due_date >= invoice_date)
);

CREATE TABLE sales_invoice_lines (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    sales_invoice_id    BIGINT          NOT NULL,
    line_number         INT             NOT NULL,
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

    CONSTRAINT fk_sil_invoice FOREIGN KEY (sales_invoice_id)
        REFERENCES sales_invoices(id) ON DELETE CASCADE,
    CONSTRAINT uq_sil_number UNIQUE (sales_invoice_id, line_number),
    CONSTRAINT chk_sil_amounts CHECK (
        quantity > 0 AND unit_price >= 0 AND line_total >= 0
    )
);

-- Purchase Invoices
CREATE TABLE purchase_invoices (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    invoice_number      VARCHAR(64)     NOT NULL,
    vendor_invoice_no   VARCHAR(64),
    invoice_date        DATE            NOT NULL,
    due_date            DATE,
    vendor_id           BIGINT          NOT NULL,
    status              VARCHAR(16)     NOT NULL DEFAULT 'DRAFT',
    subtotal            NUMERIC(20,4)   NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(20,4)   NOT NULL DEFAULT 0,
    total_amount        NUMERIC(20,4)   NOT NULL DEFAULT 0,
    currency            VARCHAR(3)      NOT NULL DEFAULT 'INR',
    notes               TEXT,
    journal_entry_id    BIGINT,
    posted_at           TIMESTAMPTZ,
    posted_by           BIGINT,
    idempotency_key     VARCHAR(128),
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT fk_pi_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(id),
    CONSTRAINT uq_pi_tenant_number UNIQUE (tenant_id, invoice_number),
    CONSTRAINT uq_pi_tenant_idem UNIQUE (tenant_id, idempotency_key),
    CONSTRAINT chk_pi_status CHECK (status IN ('DRAFT', 'POSTED', 'CANCELLED')),
    CONSTRAINT chk_pi_dates CHECK (due_date IS NULL OR due_date >= invoice_date)
);

CREATE TABLE purchase_invoice_lines (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    purchase_invoice_id BIGINT          NOT NULL,
    line_number         INT             NOT NULL,
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

    CONSTRAINT fk_pil_invoice FOREIGN KEY (purchase_invoice_id)
        REFERENCES purchase_invoices(id) ON DELETE CASCADE,
    CONSTRAINT uq_pil_number UNIQUE (purchase_invoice_id, line_number),
    CONSTRAINT chk_pil_amounts CHECK (
        quantity > 0 AND unit_price >= 0 AND line_total >= 0
    )
);

CREATE INDEX idx_si_tenant_date ON sales_invoices(tenant_id, invoice_date);
CREATE INDEX idx_si_customer ON sales_invoices(tenant_id, customer_id);
CREATE INDEX idx_si_status ON sales_invoices(tenant_id, status);
CREATE INDEX idx_sil_invoice ON sales_invoice_lines(sales_invoice_id);

CREATE INDEX idx_pi_tenant_date ON purchase_invoices(tenant_id, invoice_date);
CREATE INDEX idx_pi_vendor ON purchase_invoices(tenant_id, vendor_id);
CREATE INDEX idx_pi_status ON purchase_invoices(tenant_id, status);
CREATE INDEX idx_pil_invoice ON purchase_invoice_lines(purchase_invoice_id);
