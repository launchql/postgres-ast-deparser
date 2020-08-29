-- Revert schemas/projects_private/tables/project_grants/table from pg

BEGIN;

DROP TABLE projects_private.project_grants;

COMMIT;
