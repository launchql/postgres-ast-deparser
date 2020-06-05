-- Deploy schemas/app_jobs/triggers/tg__add_job_for_row to pg

-- requires: schemas/app_jobs/schema

BEGIN;

CREATE FUNCTION app_jobs.tg__add_job_for_row() RETURNS TRIGGER AS $$
BEGIN
  PERFORM app_jobs.add_job(tg_argv[0], json_build_object('id', NEW.id));
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

COMMENT ON FUNCTION app_jobs.tg__add_job_for_row IS
  E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record id will automatically be available on the JSON payload.';

COMMIT;
