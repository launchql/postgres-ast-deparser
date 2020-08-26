-- Deploy schemas/projects_public/tables/project/triggers/timestamps to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;

ALTER TABLE projects_public.project ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE projects_public.project ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE projects_public.project ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE projects_public.project ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_projects_public_project_modtime
BEFORE UPDATE OR INSERT ON projects_public.project
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
