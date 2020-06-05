-- Deploy schemas/app_jobs/procedures/fail_job to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/jobs/table
-- requires: schemas/app_jobs/tables/job_queues/table

BEGIN;

CREATE FUNCTION app_jobs.fail_job(worker_id varchar, job_id int, error_message varchar) RETURNS app_jobs.jobs AS $$
DECLARE
  v_row app_jobs.jobs;
BEGIN
  UPDATE app_jobs.jobs
    SET
      last_error = error_message,
      run_at = greatest(now(), run_at) + (exp(least(attempts, 10))::text || ' seconds')::interval
    WHERE id = job_id
    RETURNING * INTO v_row;

  UPDATE app_jobs.job_queues
    SET locked_by = null, locked_at = null
    WHERE queue_name = v_row.queue_name AND locked_by = worker_id;

  RETURN v_row;
END;
$$ LANGUAGE plpgsql;

COMMIT;
