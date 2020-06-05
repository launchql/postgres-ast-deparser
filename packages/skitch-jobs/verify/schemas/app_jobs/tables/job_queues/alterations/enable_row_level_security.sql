-- Verify schemas/app_jobs/tables/job_queues/alterations/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('app_jobs.job_queues');

ROLLBACK;
