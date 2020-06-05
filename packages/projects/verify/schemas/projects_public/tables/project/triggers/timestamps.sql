-- Verify schemas/projects_public/tables/project/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM projects_public.project LIMIT 1;
SELECT updated_at FROM projects_public.project LIMIT 1;
SELECT verify_trigger ('projects_public.update_projects_public_project_modtime');

ROLLBACK;
