-- Deploy schemas/app_jobs/procedures/do_notify to pg

-- requires: schemas/app_jobs/schema

BEGIN;


CREATE FUNCTION app_jobs.do_notify() RETURNS trigger AS $$
BEGIN
  PERFORM pg_notify(TG_ARGV[0], '');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMIT;
