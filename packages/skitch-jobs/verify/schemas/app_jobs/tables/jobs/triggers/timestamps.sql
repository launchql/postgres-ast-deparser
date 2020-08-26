-- Verify schemas/app_jobs/tables/jobs/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM app_jobs.jobs LIMIT 1;
SELECT updated_at FROM app_jobs.jobs LIMIT 1;
SELECT verify_trigger ('app_jobs.update_app_jobs_jobs_modtime');

ROLLBACK;
