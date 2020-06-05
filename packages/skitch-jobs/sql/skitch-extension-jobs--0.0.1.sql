\echo Use "CREATE EXTENSION skitch-extension-jobs" to load this file. \quit
CREATE SCHEMA app_jobs;

CREATE TABLE app_jobs.jobs (
 	id serial PRIMARY KEY,
	queue_name varchar DEFAULT ( public.gen_random_uuid()::varchar ) NOT NULL,
	task_identifier varchar NOT NULL,
	payload json DEFAULT ( '{}'::json ) NOT NULL,
	priority int DEFAULT ( 0 ) NOT NULL,
	run_at pg_catalog.timestamptz DEFAULT ( now() ) NOT NULL,
	attempts int DEFAULT ( 0 ) NOT NULL,
	last_error varchar 
);

CREATE FUNCTION app_jobs.add_job ( identifier varchar, payload json ) RETURNS app_jobs.jobs AS $EOFCODE$

  INSERT INTO app_jobs.jobs(task_identifier, payload)
  VALUES(identifier, payload)
  RETURNING *;

$EOFCODE$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE FUNCTION app_jobs.add_job ( identifier varchar, queue_name varchar, payload json ) RETURNS app_jobs.jobs AS $EOFCODE$

  INSERT INTO app_jobs.jobs(task_identifier, queue_name, payload)
  VALUES(identifier, queue_name, payload)
  RETURNING *;

$EOFCODE$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE TABLE app_jobs.job_queues (
 	queue_name varchar NOT NULL PRIMARY KEY,
	job_count int DEFAULT ( 0 ) NOT NULL,
	locked_at timestamptz,
	locked_by varchar 
);

CREATE FUNCTION app_jobs.complete_job ( worker_id varchar, job_id int ) RETURNS app_jobs.jobs AS $EOFCODE$
DECLARE
  v_row app_jobs.jobs;
BEGIN
  DELETE FROM app_jobs.jobs
    WHERE id = job_id
    RETURNING * INTO v_row;

  UPDATE app_jobs.job_queues
    SET locked_by = null, locked_at = null
    WHERE queue_name = v_row.queue_name AND locked_by = worker_id;

  RETURN v_row;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION app_jobs.do_notify (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM pg_notify(TG_ARGV[0], '');
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION app_jobs.fail_job ( worker_id varchar, job_id int, error_message varchar ) RETURNS app_jobs.jobs AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION app_jobs.get_job ( worker_id varchar, identifiers varchar[] ) RETURNS app_jobs.jobs AS $EOFCODE$
DECLARE
  v_job_id int;
  v_queue_name varchar;
  v_default_job_expiry text = (4 * 60 * 60)::text;
  v_default_job_maximum_attempts text = '25';
  v_row app_jobs.jobs;
BEGIN
  IF worker_id IS NULL OR length(worker_id) < 10 THEN
    RAISE EXCEPTION 'Invalid worker ID';
  END IF;

  SELECT job_queues.queue_name, jobs.id INTO v_queue_name, v_job_id
    FROM app_jobs.job_queues
    INNER JOIN app_jobs.jobs USING (queue_name)
    WHERE (locked_at IS NULL OR locked_at < (now() - (COALESCE(current_setting('jobs.expiry', true), v_default_job_expiry) || ' seconds')::interval))
    AND run_at <= now()
    AND attempts < COALESCE(current_setting('jobs.maximum_attempts', true), v_default_job_maximum_attempts)::int
    AND (identifiers IS NULL OR task_identifier = any(identifiers))
    ORDER BY priority ASC, run_at ASC, id ASC
    LIMIT 1
    FOR UPDATE SKIP LOCKED;

  IF v_queue_name IS NULL THEN
    RETURN NULL;
  END IF;

  UPDATE app_jobs.job_queues
    SET
      locked_by = worker_id,
      locked_at = now()
    WHERE job_queues.queue_name = v_queue_name;

  UPDATE app_jobs.jobs
    SET attempts = attempts + 1
    WHERE id = v_job_id
    RETURNING * INTO v_row;

  RETURN v_row;
END;
$EOFCODE$ LANGUAGE plpgsql;

CREATE FUNCTION app_jobs.schedule_job ( identifier varchar, queue_name varchar, payload json, run_at timestamptz ) RETURNS app_jobs.jobs AS $EOFCODE$
  INSERT INTO app_jobs.jobs(task_identifier, queue_name, payload, run_at)
  VALUES(identifier, queue_name, payload, run_at)
  RETURNING *;
$EOFCODE$ LANGUAGE sql VOLATILE;

ALTER TABLE app_jobs.job_queues ENABLE ROW LEVEL SECURITY;

ALTER TABLE app_jobs.jobs ENABLE ROW LEVEL SECURITY;

CREATE FUNCTION app_jobs.tg_decrease_job_queue_count (  ) RETURNS trigger AS $EOFCODE$
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
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER decrease_job_queue_count 
 BEFORE DELETE ON app_jobs.jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE app_jobs. tg_decrease_job_queue_count (  );

CREATE FUNCTION app_jobs.tg_increase_job_queue_count (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  INSERT INTO app_jobs.job_queues(queue_name, job_count)
    VALUES(NEW.queue_name, 1)
    ON CONFLICT (queue_name) DO UPDATE SET job_count = job_queues.job_count + 1;

  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql VOLATILE;

CREATE TRIGGER increase_job_queue_count 
 AFTER INSERT ON app_jobs.jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE app_jobs. tg_increase_job_queue_count (  );

CREATE TRIGGER notify_worker 
 AFTER INSERT ON app_jobs.jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE app_jobs. do_notify ( 'jobs:insert' );

ALTER TABLE app_jobs.jobs ADD COLUMN  created_at timestamptz;

ALTER TABLE app_jobs.jobs ALTER COLUMN created_at SET DEFAULT now();

ALTER TABLE app_jobs.jobs ADD COLUMN  updated_at timestamptz;

ALTER TABLE app_jobs.jobs ALTER COLUMN updated_at SET DEFAULT now();

CREATE TRIGGER update_app_jobs_jobs_modtime 
 BEFORE INSERT OR UPDATE ON app_jobs.jobs 
 FOR EACH ROW
 EXECUTE PROCEDURE tg_update_timestamps (  );

CREATE FUNCTION app_jobs.tg__add_job_for_row (  ) RETURNS trigger AS $EOFCODE$
BEGIN
  PERFORM app_jobs.add_job(tg_argv[0], json_build_object('id', NEW.id));
  RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;

COMMENT ON FUNCTION app_jobs.tg__add_job_for_row IS E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record id will automatically be available on the JSON payload.';