-- Deploy: schemas/launchql_jobs/alterations/alt0000000002 to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_jobs/schema
-- requires: schemas/launchql_jobs/grants/usage/anonymous

BEGIN;

CREATE SCHEMA IF NOT EXISTS "launchql_jobs";
GRANT USAGE ON SCHEMA "launchql_jobs" TO administrator;
ALTER DEFAULT PRIVILEGES IN SCHEMA "launchql_jobs" GRANT EXECUTE ON FUNCTIONS TO administrator;
CREATE FUNCTION "launchql_jobs".json_build_object_apply (arguments text[])
  RETURNS json
  AS $EOFCODE$
DECLARE
  arg text;
  _sql text;
  _res json;
  args text[];
BEGIN
  _sql = 'SELECT json_build_object(';
  FOR arg IN
  SELECT
    unnest(arguments)
    LOOP
      args = array_append(args, format('''%s''', arg));
    END LOOP;
  _sql = _sql || format('%s);', array_to_string(args, ','));
  EXECUTE _sql INTO _res;
  RETURN _res;
END;
$EOFCODE$
LANGUAGE plpgsql;
CREATE TABLE "launchql_jobs".jobs (
  id bigserial PRIMARY KEY,
  queue_name text DEFAULT (public.gen_random_uuid ()::text),
  task_identifier text NOT NULL,
  payload json DEFAULT ('{}'::json) NOT NULL,
  priority int DEFAULT (0) NOT NULL,
  run_at timestamptz DEFAULT (now()) NOT NULL,
  attempts int DEFAULT (0) NOT NULL,
  max_attempts int DEFAULT (25) NOT NULL,
  key text,
  last_error text,
  locked_at timestamptz,
  locked_by text,
  CHECK (((length(KEY)) < (513))),
  CHECK (((length(task_identifier)) < (127))),
  CHECK (((max_attempts) > (0))),
  CHECK (((length(queue_name)) < (127))),
  CHECK (((length(locked_by)) > (3))),
  UNIQUE (KEY)
);
CREATE TABLE "launchql_jobs".job_queues (
  queue_name text NOT NULL PRIMARY KEY,
  job_count int DEFAULT (0) NOT NULL,
  locked_at timestamptz,
  locked_by text
);
CREATE FUNCTION "launchql_jobs".add_job (identifier text, payload json DEFAULT '{}' ::json, job_key text DEFAULT NULL, queue_name text DEFAULT NULL, run_at timestamptz DEFAULT now(), max_attempts int DEFAULT 25, priority int DEFAULT 0)
  RETURNS "launchql_jobs".jobs
  AS $EOFCODE$
DECLARE
  v_job "launchql_jobs".jobs;
BEGIN
  IF job_key IS NOT NULL THEN
    INSERT INTO "launchql_jobs".jobs (task_identifier, payload, queue_name, run_at, max_attempts, KEY, priority)
      VALUES (identifier, coalesce(payload, '{}'::json), queue_name, coalesce(run_at, now()), coalesce(max_attempts, 25), job_key, coalesce(priority, 0))
    ON CONFLICT (KEY)
      DO UPDATE SET
        task_identifier = excluded.task_identifier, payload = excluded.payload, queue_name = excluded.queue_name, max_attempts = excluded.max_attempts, run_at = excluded.run_at, priority = excluded.priority,
        attempts = 0, last_error = NULL
      WHERE
        jobs.locked_at IS NULL
      RETURNING
        * INTO v_job;
    IF NOT (v_job IS NULL) THEN
      RETURN v_job;
    END IF;
    UPDATE
      "launchql_jobs".jobs
    SET
      KEY = NULL,
      attempts = jobs.max_attempts
    WHERE
      KEY = job_key;
  END IF;
  INSERT INTO "launchql_jobs".jobs (task_identifier, payload, queue_name, run_at, max_attempts, priority)
    VALUES (identifier, payload, queue_name, run_at, max_attempts, priority)
  RETURNING
    * INTO v_job;
  RETURN v_job;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
CREATE TABLE "launchql_jobs".scheduled_jobs (
  id bigserial PRIMARY KEY,
  queue_name text DEFAULT (public.gen_random_uuid ()::text),
  task_identifier text NOT NULL,
  payload json DEFAULT ('{}'::json) NOT NULL,
  priority int DEFAULT (0) NOT NULL,
  max_attempts int DEFAULT (25) NOT NULL,
  key text,
  locked_at timestamptz,
  locked_by text,
  schedule_info json NOT NULL,
  last_scheduled timestamptz,
  last_scheduled_id bigint,
  CHECK (((length(KEY)) < (513))),
  CHECK (((length(task_identifier)) < (127))),
  CHECK (((max_attempts) > (0))),
  CHECK (((length(queue_name)) < (127))),
  CHECK (((length(locked_by)) > (3))),
  UNIQUE (KEY)
);
CREATE FUNCTION "launchql_jobs".add_scheduled_job (identifier text, payload json DEFAULT '{}' ::json, schedule_info json DEFAULT '{}' ::json, job_key text DEFAULT NULL, queue_name text DEFAULT NULL, max_attempts int DEFAULT 25, priority int DEFAULT 0)
  RETURNS "launchql_jobs".scheduled_jobs
  AS $EOFCODE$
DECLARE
  v_job "launchql_jobs".scheduled_jobs;
BEGIN
  IF job_key IS NOT NULL THEN
    INSERT INTO "launchql_jobs".scheduled_jobs (task_identifier, payload, queue_name, schedule_info, max_attempts, KEY, priority)
      VALUES (identifier, coalesce(payload, '{}'::json), queue_name, schedule_info, coalesce(max_attempts, 25), job_key, coalesce(priority, 0))
    ON CONFLICT (KEY)
      DO UPDATE SET
        task_identifier = excluded.task_identifier, payload = excluded.payload, queue_name = excluded.queue_name, max_attempts = excluded.max_attempts, schedule_info = excluded.schedule_info, priority = excluded.priority
      WHERE
        scheduled_jobs.locked_at IS NULL
      RETURNING
        * INTO v_job;
    IF NOT (v_job IS NULL) THEN
      RETURN v_job;
    END IF;
    DELETE FROM "launchql_jobs".scheduled_jobs
    WHERE KEY = job_key;
  END IF;
  INSERT INTO "launchql_jobs".scheduled_jobs (task_identifier, payload, queue_name, schedule_info, max_attempts, priority)
    VALUES (identifier, payload, queue_name, schedule_info, max_attempts, priority)
  RETURNING
    * INTO v_job;
  RETURN v_job;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
CREATE FUNCTION "launchql_jobs".complete_job (worker_id text, job_id bigint)
  RETURNS "launchql_jobs".jobs
  LANGUAGE plpgsql
  AS $EOFCODE$
DECLARE
  v_row "launchql_jobs".jobs;
BEGIN
  DELETE FROM "launchql_jobs".jobs
  WHERE id = job_id
  RETURNING
    * INTO v_row;
  IF v_row.queue_name IS NOT NULL THEN
    UPDATE
      "launchql_jobs".job_queues
    SET
      locked_by = NULL,
      locked_at = NULL
    WHERE
      queue_name = v_row.queue_name
      AND locked_by = worker_id;
  END IF;
  RETURN v_row;
END;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".complete_jobs (job_ids bigint[])
  RETURNS SETOF "launchql_jobs".jobs
  LANGUAGE sql
  AS $EOFCODE$
  DELETE FROM "launchql_jobs".jobs
  WHERE id = ANY (job_ids)
    AND (locked_by IS NULL
      OR locked_at < NOW() - interval '4 hours')
  RETURNING
    *;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".do_notify ()
  RETURNS TRIGGER
  AS $EOFCODE$
BEGIN
  PERFORM
    pg_notify(TG_ARGV[0], '');
  RETURN NEW;
END;
$EOFCODE$
LANGUAGE plpgsql;
CREATE FUNCTION "launchql_jobs".fail_job (worker_id text, job_id bigint, error_message text)
  RETURNS "launchql_jobs".jobs
  LANGUAGE plpgsql
  STRICT
  AS $EOFCODE$
DECLARE
  v_row "launchql_jobs".jobs;
BEGIN
  UPDATE
    "launchql_jobs".jobs
  SET
    last_error = error_message,
    run_at = greatest (now(), run_at) + (exp(least (attempts, 10))::text || ' seconds')::interval,
    locked_by = NULL,
    locked_at = NULL
  WHERE
    id = job_id
    AND locked_by = worker_id
  RETURNING
    * INTO v_row;
  IF v_row.queue_name IS NOT NULL THEN
    UPDATE
      "launchql_jobs".job_queues
    SET
      locked_by = NULL,
      locked_at = NULL
    WHERE
      queue_name = v_row.queue_name
      AND locked_by = worker_id;
  END IF;
  RETURN v_row;
END;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".get_job (worker_id text, task_identifiers text[] DEFAULT NULL, job_expiry interval DEFAULT '4 hours')
  RETURNS "launchql_jobs".jobs
  LANGUAGE plpgsql
  AS $EOFCODE$
DECLARE
  v_job_id bigint;
  v_queue_name text;
  v_row "launchql_jobs".jobs;
  v_now timestamptz = now();
BEGIN
  IF worker_id IS NULL THEN
    RAISE exception 'INVALID_WORKER_ID';
  END IF;
  SELECT
    jobs.queue_name,
    jobs.id INTO v_queue_name,
    v_job_id
  FROM
    "launchql_jobs".jobs
  WHERE (jobs.locked_at IS NULL
    OR jobs.locked_at < (v_now - job_expiry))
    AND (jobs.queue_name IS NULL
      OR EXISTS (
        SELECT
          1
        FROM
          "launchql_jobs".job_queues
        WHERE
          job_queues.queue_name = jobs.queue_name
          AND (job_queues.locked_at IS NULL
            OR job_queues.locked_at < (v_now - job_expiry))
        FOR UPDATE
          SKIP LOCKED))
    AND run_at <= v_now
    AND attempts < max_attempts
    AND (task_identifiers IS NULL
      OR task_identifier = ANY (task_identifiers))
  ORDER BY
    priority ASC,
    run_at ASC,
    id ASC
  LIMIT 1
  FOR UPDATE
    SKIP LOCKED;
  IF v_job_id IS NULL THEN
    RETURN NULL;
  END IF;
  IF v_queue_name IS NOT NULL THEN
    UPDATE
      "launchql_jobs".job_queues
    SET
      locked_by = worker_id,
      locked_at = v_now
    WHERE
      job_queues.queue_name = v_queue_name;
  END IF;
  UPDATE
    "launchql_jobs".jobs
  SET
    attempts = attempts + 1,
    locked_by = worker_id,
    locked_at = v_now
  WHERE
    id = v_job_id
  RETURNING
    * INTO v_row;
  RETURN v_row;
END;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".get_scheduled_job (worker_id text, task_identifiers text[] DEFAULT NULL)
  RETURNS "launchql_jobs".scheduled_jobs
  LANGUAGE plpgsql
  AS $EOFCODE$
DECLARE
  v_job_id bigint;
  v_row "launchql_jobs".scheduled_jobs;
BEGIN
  IF worker_id IS NULL THEN
    RAISE exception 'INVALID_WORKER_ID';
  END IF;
  SELECT
    scheduled_jobs.id INTO v_job_id
  FROM
    "launchql_jobs".scheduled_jobs
  WHERE (scheduled_jobs.locked_at IS NULL)
    AND (task_identifiers IS NULL
      OR task_identifier = ANY (task_identifiers))
  ORDER BY
    priority ASC,
    id ASC
  LIMIT 1
  FOR UPDATE
    SKIP LOCKED;
  IF v_job_id IS NULL THEN
    RETURN NULL;
  END IF;
  UPDATE
    "launchql_jobs".scheduled_jobs
  SET
    locked_by = worker_id,
    locked_at = NOW()
  WHERE
    id = v_job_id
  RETURNING
    * INTO v_row;
  RETURN v_row;
END;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".permanently_fail_jobs (job_ids bigint[], error_message text DEFAULT NULL)
  RETURNS SETOF "launchql_jobs".jobs
  LANGUAGE sql
  AS $EOFCODE$
  UPDATE
    "launchql_jobs".jobs
  SET
    last_error = coalesce(error_message, 'Manually marked as failed'),
    attempts = max_attempts
  WHERE
    id = ANY (job_ids)
    AND (locked_by IS NULL
      OR locked_at < NOW() - interval '4 hours')
  RETURNING
    *;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".release_jobs (worker_id text)
  RETURNS void
  AS $EOFCODE$
DECLARE
BEGIN
  UPDATE
    "launchql_jobs".jobs
  SET
    locked_at = NULL,
    locked_by = NULL,
    attempts = GREATEST (attempts - 1, 0)
  WHERE
    locked_by = worker_id;
  UPDATE
    "launchql_jobs".job_queues
  SET
    locked_at = NULL,
    locked_by = NULL
  WHERE
    locked_by = worker_id;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE;
CREATE FUNCTION "launchql_jobs".release_scheduled_jobs (worker_id text, ids bigint[] DEFAULT NULL)
  RETURNS void
  AS $EOFCODE$
DECLARE
BEGIN
  UPDATE
    "launchql_jobs".scheduled_jobs s
  SET
    locked_at = NULL,
    locked_by = NULL
  WHERE
    locked_by = worker_id
    AND (ids IS NULL
      OR s.id = ANY (ids));
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE;
CREATE FUNCTION "launchql_jobs".reschedule_jobs (job_ids bigint[], run_at timestamptz DEFAULT NULL, priority int DEFAULT NULL, attempts int DEFAULT NULL, max_attempts int DEFAULT NULL)
  RETURNS SETOF "launchql_jobs".jobs
  LANGUAGE sql
  AS $EOFCODE$
  UPDATE
    "launchql_jobs".jobs
  SET
    run_at = coalesce(reschedule_jobs.run_at, jobs.run_at),
    priority = coalesce(reschedule_jobs.priority, jobs.priority),
    attempts = coalesce(reschedule_jobs.attempts, jobs.attempts),
    max_attempts = coalesce(reschedule_jobs.max_attempts, jobs.max_attempts)
  WHERE
    id = ANY (job_ids)
    AND (locked_by IS NULL
      OR locked_at < NOW() - interval '4 hours')
  RETURNING
    *;
$EOFCODE$;
CREATE FUNCTION "launchql_jobs".run_scheduled_job (id bigint, job_expiry interval DEFAULT '1 hours')
  RETURNS "launchql_jobs".jobs
  AS $EOFCODE$
DECLARE
  j "launchql_jobs".jobs;
  last_id bigint;
  lkd_by text;
BEGIN
  SELECT
    last_scheduled_id
  FROM
    "launchql_jobs".scheduled_jobs s
  WHERE
    s.id = run_scheduled_job.id INTO last_id;
  IF (last_id IS NOT NULL) THEN
    SELECT
      locked_by
    FROM
      "launchql_jobs".jobs js
    WHERE
      js.id = last_id
      AND (js.locked_at IS NULL -- never been run
        OR js.locked_at >= (NOW() - job_expiry)
) INTO lkd_by;
    IF (FOUND) THEN
      RAISE EXCEPTION 'ALREADY_SCHEDULED';
    END IF;
  END IF;
  INSERT INTO "launchql_jobs".jobs (queue_name, task_identifier, payload, priority, max_attempts, KEY)
  SELECT
    queue_name,
    task_identifier,
    payload,
    priority,
    max_attempts,
    KEY
  FROM
    "launchql_jobs".scheduled_jobs s
  WHERE
    s.id = run_scheduled_job.id
  RETURNING
    * INTO j;
  UPDATE
    "launchql_jobs".scheduled_jobs s
  SET
    last_scheduled = NOW(),
    last_scheduled_id = j.id
  WHERE
    s.id = run_scheduled_job.id;
  RETURN j;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "launchql_jobs".job_queues TO administrator;
CREATE INDEX job_queues_locked_by_idx ON "launchql_jobs".job_queues (locked_by);
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "launchql_jobs".jobs TO administrator;
CREATE INDEX jobs_locked_by_idx ON "launchql_jobs".jobs (locked_by);
CREATE INDEX priority_run_at_id_idx ON "launchql_jobs".jobs (priority, run_at, id);
CREATE FUNCTION "launchql_jobs".tg_decrease_job_queue_count ()
  RETURNS TRIGGER
  AS $EOFCODE$
DECLARE
  v_new_job_count int;
BEGIN
  UPDATE
    "launchql_jobs".job_queues
  SET
    job_count = job_queues.job_count - 1
  WHERE
    queue_name = OLD.queue_name
  RETURNING
    job_count INTO v_new_job_count;
  IF v_new_job_count <= 0 THEN
    DELETE FROM "launchql_jobs".job_queues
    WHERE queue_name = OLD.queue_name
      AND job_count <= 0;
  END IF;
  RETURN OLD;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE;
CREATE TRIGGER decrease_job_queue_count_on_delete
  AFTER DELETE ON "launchql_jobs".jobs
  FOR EACH ROW
  WHEN (old.queue_name IS NOT NULL)
  EXECUTE PROCEDURE "launchql_jobs". tg_decrease_job_queue_count ();
CREATE TRIGGER decrease_job_queue_count_on_update
  AFTER UPDATE OF queue_name ON "launchql_jobs".jobs
  FOR EACH ROW
  WHEN ((new.queue_name IS DISTINCT FROM old.queue_name AND old.queue_name IS NOT NULL))
  EXECUTE PROCEDURE "launchql_jobs". tg_decrease_job_queue_count ();
CREATE FUNCTION "launchql_jobs".tg_increase_job_queue_count ()
  RETURNS TRIGGER
  AS $EOFCODE$
BEGIN
  INSERT INTO "launchql_jobs".job_queues (queue_name, job_count)
    VALUES (NEW.queue_name, 1)
  ON CONFLICT (queue_name)
    DO UPDATE SET
      job_count = job_queues.job_count + 1;
  RETURN NEW;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE;
CREATE TRIGGER _500_increase_job_queue_count_on_insert
  AFTER INSERT ON "launchql_jobs".jobs
  FOR EACH ROW
  WHEN (NEW.queue_name IS NOT NULL)
  EXECUTE PROCEDURE "launchql_jobs". tg_increase_job_queue_count ();
CREATE TRIGGER _500_increase_job_queue_count_on_update
  AFTER UPDATE OF queue_name ON "launchql_jobs".jobs
  FOR EACH ROW
  WHEN ((NEW.queue_name IS DISTINCT FROM OLD.queue_name AND NEW.queue_name IS NOT NULL))
  EXECUTE PROCEDURE "launchql_jobs". tg_increase_job_queue_count ();
CREATE TRIGGER _900_notify_worker
  AFTER INSERT ON "launchql_jobs".jobs
  FOR EACH ROW
  EXECUTE PROCEDURE "launchql_jobs". do_notify ('jobs:insert');
CREATE FUNCTION "launchql_jobs".tg_update_timestamps ()
  RETURNS TRIGGER
  AS $EOFCODE$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_at = NOW();
    NEW.updated_at = NOW();
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.created_at = OLD.created_at;
    NEW.updated_at = greatest (now(), OLD.updated_at + interval '1 millisecond');
  END IF;
  RETURN NEW;
END;
$EOFCODE$
LANGUAGE plpgsql;
ALTER TABLE "launchql_jobs".jobs
  ADD COLUMN created_at timestamptz;
ALTER TABLE "launchql_jobs".jobs
  ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE "launchql_jobs".jobs
  ADD COLUMN updated_at timestamptz;
ALTER TABLE "launchql_jobs".jobs
  ALTER COLUMN updated_at SET DEFAULT now();
CREATE TRIGGER _100_update_jobs_modtime_tg
  BEFORE INSERT OR UPDATE ON "launchql_jobs".jobs
  FOR EACH ROW
  EXECUTE PROCEDURE "launchql_jobs". tg_update_timestamps ();
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "launchql_jobs".scheduled_jobs TO administrator;
CREATE INDEX scheduled_jobs_locked_by_idx ON "launchql_jobs".scheduled_jobs (locked_by);
CREATE INDEX scheduled_jobs_priority_id_idx ON "launchql_jobs".scheduled_jobs (priority, id);
CREATE TRIGGER _900_notify_scheduled_job
  AFTER INSERT ON "launchql_jobs".scheduled_jobs
  FOR EACH ROW
  EXECUTE PROCEDURE "launchql_jobs". do_notify ('scheduled_jobs:insert');
CREATE FUNCTION "launchql_jobs".trigger_job_with_fields ()
  RETURNS TRIGGER
  AS $EOFCODE$
DECLARE
  arg text;
  fn text;
  i int;
  args text[];
BEGIN
  FOR i IN
  SELECT
    *
  FROM
    generate_series(1, TG_NARGS) g (i)
    LOOP
      IF (i = 1) THEN
        fn = TG_ARGV[i - 1];
      ELSE
        args = array_append(args, TG_ARGV[i - 1]);
        IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
          EXECUTE format('SELECT ($1).%s::text', TG_ARGV[i - 1])
          USING NEW INTO arg;
        END IF;
        IF (TG_OP = 'DELETE') THEN
          EXECUTE format('SELECT ($1).%s::text', TG_ARGV[i - 1])
          USING OLD INTO arg;
        END IF;
        args = array_append(args, arg);
      END IF;
    END LOOP;
  PERFORM
    "launchql_jobs".add_job (fn, "launchql_jobs".json_build_object_apply (args));
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
CREATE FUNCTION "launchql_jobs".tg_add_job_with_row_id ()
  RETURNS TRIGGER
  AS $EOFCODE$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM
      "launchql_jobs".add_job (tg_argv[0], json_build_object('id', NEW.id));
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    PERFORM
      "launchql_jobs".add_job (tg_argv[0], json_build_object('id', OLD.id));
    RETURN OLD;
  END IF;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
COMMENT ON FUNCTION "launchql_jobs".tg_add_job_with_row_id IS E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record id will automatically be available on the JSON payload.';
CREATE FUNCTION "launchql_jobs".tg_add_job_with_row ()
  RETURNS TRIGGER
  AS $EOFCODE$
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    PERFORM
      "launchql_jobs".add_job (TG_ARGV[0], to_json(NEW));
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    PERFORM
      "launchql_jobs".add_job (TG_ARGV[0], to_json(OLD));
    RETURN OLD;
  END IF;
END;
$EOFCODE$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER;
COMMENT ON FUNCTION "launchql_jobs".tg_add_job_with_row IS E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record data will automatically be available on the JSON payload.';
COMMIT;
