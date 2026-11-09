-- =====================================================================
-- V14: Audit Logs
-- Append-only immutable log of every significant action.
-- Distinct from application logs (which go to files).
-- Designed for FINANCIAL AUDIT: queryable, immutable, indexed.
-- =====================================================================

CREATE TABLE audit_logs (
    id              BIGSERIAL       PRIMARY KEY,
    tenant_id       BIGINT,
    user_id         BIGINT,
    action          VARCHAR(64)     NOT NULL,
    entity_type     VARCHAR(64),
    entity_id       BIGINT,
    outcome         VARCHAR(16)     NOT NULL,
    details         JSONB,
    ip_address      VARCHAR(64),
    user_agent      VARCHAR(512),
    correlation_id  VARCHAR(64),
    duration_ms     BIGINT,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_audit_outcome CHECK (outcome IN ('SUCCESS', 'FAILURE'))
);

-- Audit queries to be fast for auditor use cases.
CREATE INDEX idx_audit_tenant_time ON audit_logs(tenant_id, created_at DESC);
CREATE INDEX idx_audit_user_time ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_action_time ON audit_logs(tenant_id, action, created_at DESC);
CREATE INDEX idx_audit_entity ON audit_logs(tenant_id, entity_type, entity_id);
CREATE INDEX idx_audit_correlation ON audit_logs(correlation_id)
    WHERE correlation_id IS NOT NULL;

-- IMMUTABILITY: block UPDATE and DELETE on audit_logs.
CREATE OR REPLACE FUNCTION prevent_audit_log_mutation()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'audit_logs is append-only. Cannot % row (id=%).',
        TG_OP, COALESCE(OLD.id, 0)
        USING ERRCODE = 'restrict_violation';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_no_update
BEFORE UPDATE ON audit_logs
FOR EACH ROW EXECUTE FUNCTION prevent_audit_log_mutation();

CREATE TRIGGER trg_audit_no_delete
BEFORE DELETE ON audit_logs
FOR EACH ROW EXECUTE FUNCTION prevent_audit_log_mutation();
