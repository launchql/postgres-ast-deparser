-- Revert schemas/projects_private/tables/project_secrets/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE projects_private.project_secrets
    DISABLE ROW LEVEL SECURITY;

COMMIT;
