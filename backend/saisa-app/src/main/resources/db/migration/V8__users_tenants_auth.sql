-- =====================================================================
-- V8: Tenants, Users, Roles, Refresh Tokens
-- =====================================================================

CREATE TABLE tenants (
    id              BIGSERIAL       PRIMARY KEY,
    version         BIGINT          NOT NULL DEFAULT 0,
    tenant_code     VARCHAR(64)     NOT NULL,
    company_name    VARCHAR(255)    NOT NULL,
    legal_name      VARCHAR(255),
    gstin           VARCHAR(15),
    pan             VARCHAR(10),
    address         TEXT,
    city            VARCHAR(100),
    state           VARCHAR(100),
    country         VARCHAR(64)     NOT NULL DEFAULT 'India',
    pincode         VARCHAR(20),
    phone           VARCHAR(32),
    email           VARCHAR(255),
    fiscal_year_start_month INT      NOT NULL DEFAULT 4,
    status          VARCHAR(16)     NOT NULL DEFAULT 'ACTIVE',
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,

    CONSTRAINT uq_tenants_code UNIQUE (tenant_code),
    CONSTRAINT chk_tenants_status CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED')),
    CONSTRAINT chk_tenants_fy_month CHECK (fiscal_year_start_month BETWEEN 1 AND 12)
);

CREATE TABLE users (
    id              BIGSERIAL       PRIMARY KEY,
    version         BIGINT          NOT NULL DEFAULT 0,
    tenant_id       BIGINT          NOT NULL,
    username        VARCHAR(64)     NOT NULL,
    email           VARCHAR(255)    NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    full_name       VARCHAR(255),
    status          VARCHAR(16)     NOT NULL DEFAULT 'ACTIVE',
    last_login_at   TIMESTAMPTZ,
    failed_login_attempts INT        NOT NULL DEFAULT 0,
    locked_until    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_by      BIGINT,
    updated_by      BIGINT,

    CONSTRAINT fk_users_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id),
    CONSTRAINT uq_users_tenant_username UNIQUE (tenant_id, username),
    CONSTRAINT uq_users_tenant_email UNIQUE (tenant_id, email),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE', 'DISABLED', 'LOCKED'))
);

CREATE TABLE roles (
    id              BIGSERIAL       PRIMARY KEY,
    role_code       VARCHAR(32)     NOT NULL,
    role_name       VARCHAR(64)     NOT NULL,
    description     TEXT,
    CONSTRAINT uq_roles_code UNIQUE (role_code)
);

CREATE TABLE user_roles (
    user_id         BIGINT          NOT NULL,
    role_id         BIGINT          NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_ur_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ur_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

CREATE TABLE refresh_tokens (
    id              BIGSERIAL       PRIMARY KEY,
    user_id         BIGINT          NOT NULL,
    token_hash      VARCHAR(128)    NOT NULL,
    expires_at      TIMESTAMPTZ     NOT NULL,
    revoked         BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    revoked_at      TIMESTAMPTZ,

    CONSTRAINT fk_rt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uq_rt_token UNIQUE (token_hash)
);

CREATE INDEX idx_users_tenant_username ON users(tenant_id, username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_rt_user ON refresh_tokens(user_id);
CREATE INDEX idx_rt_hash ON refresh_tokens(token_hash) WHERE NOT revoked;

INSERT INTO roles (role_code, role_name, description) VALUES
  ('ADMIN',       'Administrator',    'Full access to all features'),
  ('ACCOUNTANT',  'Accountant',       'Can post entries and view reports'),
  ('VIEWER',      'Viewer',           'Read-only access to reports');
