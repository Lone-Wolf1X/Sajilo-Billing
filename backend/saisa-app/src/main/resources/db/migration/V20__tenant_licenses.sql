-- Migration V20: Add tenant_licenses table for Commercial License Subsystem

CREATE TABLE IF NOT EXISTS tenant_licenses (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    license_id VARCHAR(64) NOT NULL UNIQUE,
    plan VARCHAR(32) NOT NULL,
    max_users INT NOT NULL DEFAULT 1,
    allowed_features TEXT NOT NULL,
    issued_at TIMESTAMPTZ NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    raw_payload TEXT NOT NULL,
    signature TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tenant_licenses_tenant_id ON tenant_licenses(tenant_id);
CREATE INDEX IF NOT EXISTS idx_tenant_licenses_is_active ON tenant_licenses(tenant_id, is_active);
