-- Revert schemas/app_jobs/tables/jobs/triggers/increase_job_queue_count from pg

BEGIN;

DROP TRIGGER increase_job_queue_count ON app_jobs.jobs;
DROP FUNCTION app_jobs.tg_increase_job_queue_count; 

COMMIT;
