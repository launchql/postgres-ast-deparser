-- Verify schemas/permissions_public/tables/permission/grants/grant_select_to_authenticated on pg

BEGIN;

  SELECT has_table_privilege('authenticated', 'permissions_public.permission', 'SELECT');
  
ROLLBACK;
