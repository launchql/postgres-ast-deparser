-- Revert schemas/app_jobs/triggers/tg__add_job_for_row from pg

BEGIN;

DROP FUNCTION app_jobs.tg__add_job_for_row;

COMMIT;
