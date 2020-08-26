-- Revert schemas/app_jobs/tables/jobs/triggers/timestamps from pg

BEGIN;

ALTER TABLE app_jobs.jobs DROP COLUMN created_at;
ALTER TABLE app_jobs.jobs DROP COLUMN updated_at;
DROP TRIGGER update_app_jobs_jobs_modtime ON app_jobs.jobs;

COMMIT;
