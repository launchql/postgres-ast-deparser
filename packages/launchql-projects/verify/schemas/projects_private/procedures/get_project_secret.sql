-- Verify schemas/projects_private/procedures/get_project_secret  on pg

BEGIN;

SELECT verify_function ('projects_private.get_project_secret');

ROLLBACK;
