-- V19: Add CASHIER role for retail POS operators
INSERT INTO roles (role_code, role_name, description) VALUES
  ('CASHIER', 'Cashier', 'POS billing and receipt issuing only')
ON CONFLICT (role_code) DO NOTHING;

