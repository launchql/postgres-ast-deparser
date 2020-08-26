-- Verify schemas/app_jobs/triggers/tg__add_job_for_row  on pg

BEGIN;

SELECT verify_function ('app_jobs.tg__add_job_for_row');

ROLLBACK;
