-- Revert schemas/projects_public/tables/project/triggers/timestamps from pg

BEGIN;

ALTER TABLE projects_public.project DROP COLUMN created_at;
ALTER TABLE projects_public.project DROP COLUMN updated_at;
DROP TRIGGER update_projects_public_project_modtime ON projects_public.project;

COMMIT;
