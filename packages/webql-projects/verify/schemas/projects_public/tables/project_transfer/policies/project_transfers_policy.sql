-- Verify schemas/projects_public/tables/project_transfer/policies/project_transfers_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_project_transfers', 'projects_public.project_transfers');
SELECT verify_policy ('can_insert_project_transfers', 'projects_public.project_transfers');
SELECT verify_policy ('can_update_project_transfers', 'projects_public.project_transfers');
SELECT verify_policy ('can_delete_project_transfers', 'projects_public.project_transfers');

SELECT has_table_privilege('authenticated', 'projects_public.project_transfers', 'INSERT');
SELECT has_table_privilege('authenticated', 'projects_public.project_transfers', 'SELECT');
SELECT has_table_privilege('authenticated', 'projects_public.project_transfers', 'UPDATE');
SELECT has_table_privilege('authenticated', 'projects_public.project_transfers', 'DELETE');

ROLLBACK;
