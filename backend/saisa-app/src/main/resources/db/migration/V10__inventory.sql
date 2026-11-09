-- =====================================================================
-- V10: Inventory - Items, Warehouses, Stock Movements, Stock Balances
-- Stock movements are IMMUTABLE (like journal entries).
-- Stock balances are the fast-read aggregate.
-- =====================================================================

CREATE TABLE items (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    sku                 VARCHAR(64)     NOT NULL,
    name                VARCHAR(255)    NOT NULL,
    description         TEXT,
    unit_of_measure     VARCHAR(16)     NOT NULL DEFAULT 'NOS',
    hsn_code            VARCHAR(16),
    tracks_inventory    BOOLEAN         NOT NULL DEFAULT TRUE,
    sale_price          NUMERIC(20,4)   NOT NULL DEFAULT 0,
    purchase_price      NUMERIC(20,4)   NOT NULL DEFAULT 0,
    reorder_level       NUMERIC(20,4),
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT uq_items_tenant_sku UNIQUE (tenant_id, sku)
);

CREATE TABLE warehouses (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    code                VARCHAR(32)     NOT NULL,
    name                VARCHAR(255)    NOT NULL,
    address             TEXT,
    is_default          BOOLEAN         NOT NULL DEFAULT FALSE,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,
    updated_by          BIGINT,

    CONSTRAINT uq_wh_tenant_code UNIQUE (tenant_id, code)
);

-- Immutable stock ledger: every in/out is a row.
CREATE TABLE stock_movements (
    id                  BIGSERIAL       PRIMARY KEY,
    tenant_id           BIGINT          NOT NULL,
    item_id             BIGINT          NOT NULL,
    warehouse_id        BIGINT          NOT NULL,
    movement_type       VARCHAR(32)     NOT NULL,
    movement_date       DATE            NOT NULL,
    quantity_in         NUMERIC(20,4)   NOT NULL DEFAULT 0,
    quantity_out        NUMERIC(20,4)   NOT NULL DEFAULT 0,
    unit_cost           NUMERIC(20,4)   NOT NULL,
    total_value         NUMERIC(20,4)   NOT NULL,
    wac_after           NUMERIC(20,4)   NOT NULL,
    reference_type      VARCHAR(32),
    reference_id        BIGINT,
    notes               TEXT,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by          BIGINT,

    CONSTRAINT fk_sm_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_sm_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
    CONSTRAINT chk_sm_type CHECK (movement_type IN
        ('PURCHASE_RECEIPT', 'SALE_ISSUE', 'ADJUSTMENT_IN', 'ADJUSTMENT_OUT',
         'SALES_RETURN', 'PURCHASE_RETURN', 'OPENING')),
    CONSTRAINT chk_sm_one_direction CHECK (
        (quantity_in > 0 AND quantity_out = 0) OR
        (quantity_in = 0 AND quantity_out > 0)
    )
);

CREATE INDEX idx_sm_tenant_item ON stock_movements(tenant_id, item_id, movement_date);
CREATE INDEX idx_sm_tenant_warehouse ON stock_movements(tenant_id, warehouse_id, movement_date);
CREATE INDEX idx_sm_reference ON stock_movements(tenant_id, reference_type, reference_id);

-- Fast current state per (item, warehouse).
CREATE TABLE stock_balances (
    id                  BIGSERIAL       PRIMARY KEY,
    version             BIGINT          NOT NULL DEFAULT 0,
    tenant_id           BIGINT          NOT NULL,
    item_id             BIGINT          NOT NULL,
    warehouse_id        BIGINT          NOT NULL,
    quantity_on_hand    NUMERIC(20,4)   NOT NULL DEFAULT 0,
    wac                 NUMERIC(20,4)   NOT NULL DEFAULT 0,
    inventory_value     NUMERIC(20,4)   NOT NULL DEFAULT 0,
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_sb_item FOREIGN KEY (item_id) REFERENCES items(id),
    CONSTRAINT fk_sb_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
    CONSTRAINT uq_sb_item_wh UNIQUE (tenant_id, item_id, warehouse_id),
    CONSTRAINT chk_sb_non_negative CHECK (
        quantity_on_hand >= 0 AND wac >= 0 AND inventory_value >= 0
    )
);

CREATE INDEX idx_sb_tenant_item ON stock_balances(tenant_id, item_id);

-- Add item_id to invoice lines (nullable — backward compatible)
ALTER TABLE sales_invoice_lines
    ADD COLUMN item_id BIGINT,
    ADD CONSTRAINT fk_sil_item FOREIGN KEY (item_id) REFERENCES items(id);

ALTER TABLE purchase_invoice_lines
    ADD COLUMN item_id BIGINT,
    ADD CONSTRAINT fk_pil_item FOREIGN KEY (item_id) REFERENCES items(id);

-- Add warehouse_id to invoice headers (nullable — default warehouse used if null)
ALTER TABLE sales_invoices
    ADD COLUMN warehouse_id BIGINT,
    ADD CONSTRAINT fk_si_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses(id);

ALTER TABLE purchase_invoices
    ADD COLUMN warehouse_id BIGINT,
    ADD CONSTRAINT fk_pi_wh FOREIGN KEY (warehouse_id) REFERENCES warehouses(id);

CREATE INDEX idx_sil_item ON sales_invoice_lines(item_id) WHERE item_id IS NOT NULL;
CREATE INDEX idx_pil_item ON purchase_invoice_lines(item_id) WHERE item_id IS NOT NULL;

