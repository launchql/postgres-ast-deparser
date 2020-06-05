-- Deploy schemas/app_jobs/tables/jobs/table to pg

-- requires: schemas/app_jobs/schema

BEGIN;

CREATE TABLE app_jobs.jobs (
  id serial PRIMARY KEY,
  queue_name varchar DEFAULT (public.gen_random_uuid())::varchar NOT NULL,
  task_identifier varchar NOT NULL,
  payload json DEFAULT '{}'::json NOT NULL,
  priority int DEFAULT 0 NOT NULL,
  run_at timestamp with time zone DEFAULT now() NOT NULL,
  attempts int DEFAULT 0 NOT NULL,
  last_error varchar
);

COMMIT;
