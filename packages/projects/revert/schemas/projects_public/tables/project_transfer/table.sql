-- Revert schemas/projects_public/tables/project_transfer/table from pg

BEGIN;

DROP TABLE projects_public.project_transfers;

COMMIT;
