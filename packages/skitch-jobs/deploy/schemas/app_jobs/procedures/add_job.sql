-- Deploy schemas/app_jobs/procedures/add_job to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/jobs/table


BEGIN;

CREATE FUNCTION app_jobs.add_job(identifier varchar, payload json)
RETURNS app_jobs.jobs AS $$

  INSERT INTO app_jobs.jobs(task_identifier, payload)
  VALUES(identifier, payload)
  RETURNING *;

$$ LANGUAGE 'sql' VOLATILE SECURITY DEFINER;

CREATE FUNCTION app_jobs.add_job(identifier varchar, queue_name varchar, payload json)
RETURNS app_jobs.jobs AS $$

  INSERT INTO app_jobs.jobs(task_identifier, queue_name, payload)
  VALUES(identifier, queue_name, payload)
  RETURNING *;

$$ LANGUAGE 'sql' VOLATILE SECURITY DEFINER;

COMMIT;
