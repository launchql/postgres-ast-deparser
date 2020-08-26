-- Deploy schemas/app_jobs/tables/job_queues/table to pg

-- requires: schemas/app_jobs/schema

BEGIN;

CREATE TABLE app_jobs.job_queues (
  queue_name varchar NOT NULL PRIMARY KEY,
  job_count int DEFAULT 0 NOT NULL,
  locked_at TIMESTAMPTZ,
  locked_by varchar
);

COMMIT;
