-- Revert schemas/projects_public/tables/project/table from pg

BEGIN;

DROP TABLE projects_public.project;

COMMIT;
