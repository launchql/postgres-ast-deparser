-- Verify schemas/projects_private/procedures/get_project_master_key  on pg

BEGIN;

SELECT verify_function ('projects_private.get_project_master_key');

ROLLBACK;
