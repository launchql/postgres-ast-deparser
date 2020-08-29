-- Verify schemas/projects_public/tables/project/policies/project_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_project', 'projects_public.project');
SELECT verify_policy ('can_insert_project', 'projects_public.project');
SELECT verify_policy ('can_update_project', 'projects_public.project');
SELECT verify_policy ('can_delete_project', 'projects_public.project');

SELECT has_table_privilege('authenticated', 'projects_public.project', 'INSERT');
SELECT has_table_privilege('authenticated', 'projects_public.project', 'SELECT');
SELECT has_table_privilege('authenticated', 'projects_public.project', 'UPDATE');
SELECT has_table_privilege('authenticated', 'projects_public.project', 'DELETE');

ROLLBACK;
