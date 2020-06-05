-- Verify schemas/app_jobs/tables/jobs/triggers/increase_job_queue_count  on pg

BEGIN;

SELECT verify_function ('app_jobs.tg_increase_job_queue_count'); 
SELECT verify_trigger ('app_jobs.increase_job_queue_count');

ROLLBACK;
