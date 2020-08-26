-- Verify schemas/permissions_private/tables/profile_permissions/grants/grant_select_insert_delete_to_authenticated on pg

BEGIN;

  SELECT has_table_privilege('authenticated', 'permissions_private.profile_permissions', 'SELECT');
  SELECT has_table_privilege('authenticated', 'permissions_private.profile_permissions', 'INSERT');
  SELECT has_table_privilege('authenticated', 'permissions_private.profile_permissions', 'DELETE');
  
ROLLBACK;
