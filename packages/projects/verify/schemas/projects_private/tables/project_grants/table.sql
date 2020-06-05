-- Verify schemas/projects_private/tables/project_grants/table on pg

BEGIN;

SELECT verify_table ('projects_private.project_grants');

ROLLBACK;
