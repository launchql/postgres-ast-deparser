-- Verify schemas/projects_public/tables/project/table on pg

BEGIN;

SELECT verify_table('projects_public.project');

ROLLBACK;
