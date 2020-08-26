-- Revert schemas/app_jobs/procedures/schedule_job from pg

BEGIN;

DROP FUNCTION app_jobs.schedule_job;

COMMIT;
