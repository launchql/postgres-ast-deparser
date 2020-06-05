-- Deploy schemas/app_jobs/procedures/schedule_job to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/jobs/table

BEGIN;

CREATE FUNCTION app_jobs.schedule_job(
  identifier varchar,
  queue_name varchar,
  payload json,
  run_at timestamptz
) RETURNS app_jobs.jobs AS $$
  INSERT INTO app_jobs.jobs(task_identifier, queue_name, payload, run_at)
  VALUES(identifier, queue_name, payload, run_at)
  RETURNING *;
$$ LANGUAGE 'sql' VOLATILE;

COMMIT;
