-- Deploy schemas/app_jobs/tables/jobs/triggers/timestamps to pg

-- requires: schemas/app_jobs/schema
-- requires: schemas/app_jobs/tables/jobs/table

BEGIN;

ALTER TABLE app_jobs.jobs ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE app_jobs.jobs ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE app_jobs.jobs ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE app_jobs.jobs ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_app_jobs_jobs_modtime
BEFORE UPDATE OR INSERT ON app_jobs.jobs
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
