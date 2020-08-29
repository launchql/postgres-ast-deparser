-- Verify schemas/projects_private/tables/project_grants/grants/grant_select_insert_update_delete_to_authenticated on pg

BEGIN;

  SELECT has_table_privilege('authenticated', 'projects_private.project_grants', 'SELECT');
  SELECT has_table_privilege('authenticated', 'projects_private.project_grants', 'INSERT');
  SELECT has_table_privilege('authenticated', 'projects_private.project_grants', 'UPDATE');
  SELECT has_table_privilege('authenticated', 'projects_private.project_grants', 'DELETE');
  
ROLLBACK;
