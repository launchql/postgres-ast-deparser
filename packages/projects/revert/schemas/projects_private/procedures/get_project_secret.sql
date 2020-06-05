-- Revert schemas/projects_private/procedures/get_project_secret from pg

BEGIN;

DROP FUNCTION projects_private.get_project_secret;

COMMIT;
