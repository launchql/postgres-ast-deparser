-- Deploy schemas/app_jobs/tables/jobs/triggers/decrease_job_queue_count to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/jobs/table

BEGIN;



CREATE FUNCTION app_jobs.tg_decrease_job_queue_count()
RETURNS TRIGGER AS $$
BEGIN

  UPDATE app_jobs.job_queues
    SET job_count = job_queues.job_count - 1
    WHERE queue_name = OLD.queue_name
    AND job_queues.job_count > 1;

  IF NOT FOUND THEN
    DELETE FROM app_jobs.job_queues WHERE queue_name = OLD.queue_name;
  END IF;

  RETURN OLD;

END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER decrease_job_queue_count
BEFORE DELETE ON app_jobs.jobs
FOR EACH ROW
EXECUTE PROCEDURE app_jobs.tg_decrease_job_queue_count ();

COMMIT;
