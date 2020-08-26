-- Verify schemas/status_public/tables/user_achievement/grants/grant_select_to_authenticated on pg

BEGIN;

  SELECT has_table_privilege('authenticated', 'status_public.user_achievement', 'SELECT');
  
ROLLBACK;
