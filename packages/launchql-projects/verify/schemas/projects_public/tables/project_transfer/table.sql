-- Verify schemas/projects_public/tables/project_transfer/table on pg

BEGIN;

SELECT verify_table ('projects_public.project_transfers');

ROLLBACK;
