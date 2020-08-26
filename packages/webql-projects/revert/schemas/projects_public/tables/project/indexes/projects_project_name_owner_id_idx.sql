-- Revert schemas/projects_public/tables/project/indexes/projects_project_name_owner_id_idx from pg

BEGIN;

DROP INDEX projects_public.projects_project_name_owner_id_idx;

COMMIT;
