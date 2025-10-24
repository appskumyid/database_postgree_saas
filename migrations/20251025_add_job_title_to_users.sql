-- Add job_title to users
BEGIN;
ALTER TABLE users
ADD COLUMN job_title VARCHAR(100);
COMMIT;
