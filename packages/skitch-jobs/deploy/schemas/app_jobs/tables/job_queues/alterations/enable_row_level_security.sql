-- Deploy schemas/app_jobs/tables/job_queues/alterations/enable_row_level_security to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/job_queues/table

BEGIN;

ALTER TABLE app_jobs.job_queues ENABLE ROW LEVEL SECURITY;

COMMIT;
