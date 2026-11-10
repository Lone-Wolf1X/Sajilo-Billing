-- V18: System Email Settings
CREATE TABLE IF NOT EXISTS email_settings (
    id BIGSERIAL PRIMARY KEY,
    smtp_host VARCHAR(255) NOT NULL,
    smtp_port INT NOT NULL,
    smtp_username VARCHAR(255) NOT NULL,
    smtp_password VARCHAR(255) NOT NULL,
    from_email VARCHAR(255) NOT NULL,
    from_name VARCHAR(255) NOT NULL,
    starttls_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    auth_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Seed with initial SMTP credentials
INSERT INTO email_settings (smtp_host, smtp_port, smtp_username, smtp_password, from_email, from_name, starttls_enabled, auth_enabled)
VALUES ('smtp.gmail.com', 587, 'nextgeninnovationsprivatelimit@gmail.com', 'mdvx fwry lrmd pwsc', 'nextgeninnovationsprivatelimit@gmail.com', 'SAISA Billing & Accounting', TRUE, TRUE);
