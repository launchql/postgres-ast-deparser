-- Verify schemas/projects_private/tables/project_secrets/table on pg

BEGIN;

SELECT verify_table ('projects_private.project_secrets');

ROLLBACK;
