-- =====================================================================
-- V16: Tenant Profile Setup (Nepal Business Onboarding & Master Data)
-- =====================================================================

ALTER TABLE tenants
    ADD COLUMN IF NOT EXISTS company_name_nepali          VARCHAR(255),
    ADD COLUMN IF NOT EXISTS registration_authority       VARCHAR(100),
    ADD COLUMN IF NOT EXISTS registration_no              VARCHAR(100),
    ADD COLUMN IF NOT EXISTS registration_date            DATE,
    ADD COLUMN IF NOT EXISTS pan_vat_no                   VARCHAR(20),
    ADD COLUMN IF NOT EXISTS pan_vat_date                 DATE,
    ADD COLUMN IF NOT EXISTS province                     VARCHAR(100),
    ADD COLUMN IF NOT EXISTS district                     VARCHAR(100),
    ADD COLUMN IF NOT EXISTS municipality_vdc             VARCHAR(150),
    ADD COLUMN IF NOT EXISTS ward_no                      INTEGER,
    ADD COLUMN IF NOT EXISTS tole_street                  VARCHAR(255),
    ADD COLUMN IF NOT EXISTS incorporation_type           VARCHAR(50),
    ADD COLUMN IF NOT EXISTS business_nature              VARCHAR(50),
    ADD COLUMN IF NOT EXISTS authorized_person_name       VARCHAR(255),
    ADD COLUMN IF NOT EXISTS authorized_person_designation VARCHAR(100),
    ADD COLUMN IF NOT EXISTS authorized_person_phone      VARCHAR(20),
    ADD COLUMN IF NOT EXISTS authorized_person_email      VARCHAR(255),
    ADD COLUMN IF NOT EXISTS setup_completed              BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS setup_completed_at           TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS setup_step                   INTEGER NOT NULL DEFAULT 1;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_tenants_incorporation_type'
    ) THEN
        ALTER TABLE tenants
            ADD CONSTRAINT chk_tenants_incorporation_type CHECK (
                incorporation_type IS NULL OR incorporation_type IN (
                    'PROPRIETORSHIP', 'PARTNERSHIP', 'PRIVATE_LIMITED', 'PUBLIC_LIMITED', 'COOPERATIVE', 'NGO', 'GOVERNMENT', 'OTHER'
                )
            );
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_tenants_business_nature'
    ) THEN
        ALTER TABLE tenants
            ADD CONSTRAINT chk_tenants_business_nature CHECK (
                business_nature IS NULL OR business_nature IN (
                    'TRADING', 'MANUFACTURING', 'SERVICE', 'RETAIL', 'WHOLESALE', 'MIXED', 'OTHER'
                )
            );
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_tenants_setup_step'
    ) THEN
        ALTER TABLE tenants
            ADD CONSTRAINT chk_tenants_setup_step CHECK (
                setup_step BETWEEN 1 AND 4
            );
    END IF;
END $$;
