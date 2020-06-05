-- Verify schemas/projects_private/tables/project_secrets/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('projects_private.project_secrets');

ROLLBACK;
