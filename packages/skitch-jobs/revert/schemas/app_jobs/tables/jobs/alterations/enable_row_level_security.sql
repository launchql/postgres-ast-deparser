-- Revert schemas/app_jobs/tables/jobs/alterations/enable_row_level_security from pg

BEGIN;

ALTER TABLE app_jobs.jobs
    DISABLE ROW LEVEL SECURITY;

COMMIT;
