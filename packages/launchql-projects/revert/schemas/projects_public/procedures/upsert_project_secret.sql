-- Revert schemas/projects_public/procedures/upsert_project_secret from pg

BEGIN;

DROP FUNCTION projects_public.upsert_project_secret;

COMMIT;
