-- Add industry and founded_year columns to tenants
BEGIN;
ALTER TABLE tenants
ADD COLUMN industry VARCHAR(100),
ADD COLUMN founded_year INT;
COMMIT;
