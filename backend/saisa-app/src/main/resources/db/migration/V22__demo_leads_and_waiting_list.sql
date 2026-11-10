-- =====================================================================
-- V22: Demo Leads and Waiting List for Public Website & Platform Admin
-- =====================================================================

CREATE TABLE IF NOT EXISTS demo_leads (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    status VARCHAR(50) NOT NULL DEFAULT 'WAITING',
    requested_plan VARCHAR(50) NOT NULL DEFAULT 'DEMO_TRIAL',
    notes TEXT,
    converted_tenant_id BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_demo_leads_email ON demo_leads(email);
CREATE INDEX IF NOT EXISTS idx_demo_leads_status ON demo_leads(status);

