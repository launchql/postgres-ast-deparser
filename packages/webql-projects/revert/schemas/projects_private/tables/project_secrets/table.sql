-- Revert schemas/projects_private/tables/project_secrets/table from pg

BEGIN;

DROP TABLE projects_private.project_secrets;

COMMIT;
