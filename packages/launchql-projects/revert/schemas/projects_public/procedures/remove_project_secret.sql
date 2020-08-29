-- Revert schemas/projects_public/procedures/remove_project_secret from pg

BEGIN;

DROP FUNCTION projects_public.remove_project_secret;

COMMIT;
