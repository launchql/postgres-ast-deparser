-- Revert schemas/projects_private/procedures/get_project_master_key from pg

BEGIN;

DROP FUNCTION projects_private.get_project_master_key;

COMMIT;
