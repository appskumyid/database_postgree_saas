-- Seed default roles for SaaS system
BEGIN;
INSERT INTO roles (name, scope, description) VALUES
('administrator', 'owner', 'Akses penuh pemilik aplikasi'),
('marketing', 'owner', 'Mengelola promosi dan kampanye'),
('accounting', 'owner', 'Mengelola keuangan internal'),
('admin', 'tenant', 'Administrator tenant'),
('petugas', 'tenant', 'Petugas operasional tenant'),
('marketing', 'tenant', 'Marketing tenant'),
('accounting', 'tenant', 'Accounting tenant');
COMMIT;
