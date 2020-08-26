-- Deploy schemas/app_jobs/tables/jobs/alterations/enable_row_level_security to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/jobs/table

BEGIN;

ALTER TABLE app_jobs.jobs
    ENABLE ROW LEVEL SECURITY;

COMMIT;
