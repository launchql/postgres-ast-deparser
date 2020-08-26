-- Revert schemas/app_jobs/tables/job_queues/alterations/enable_row_level_security from pg

BEGIN;

ALTER TABLE app_jobs.job_queues
    DISABLE ROW LEVEL SECURITY;

COMMIT;
