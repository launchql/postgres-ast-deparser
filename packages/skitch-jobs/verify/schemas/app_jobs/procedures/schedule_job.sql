-- Verify schemas/app_jobs/procedures/schedule_job  on pg

BEGIN;

SELECT verify_function ('app_jobs.schedule_job');

ROLLBACK;
