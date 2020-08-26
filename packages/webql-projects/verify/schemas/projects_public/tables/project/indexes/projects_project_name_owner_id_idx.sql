-- Verify schemas/projects_public/tables/project/indexes/projects_project_name_owner_id_idx  on pg

BEGIN;

SELECT verify_index ('projects_public.project', 'projects_project_name_owner_id_idx');

ROLLBACK;
