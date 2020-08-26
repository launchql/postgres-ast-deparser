-- Verify schemas/projects_public/tables/project/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('projects_public.project');

ROLLBACK;
