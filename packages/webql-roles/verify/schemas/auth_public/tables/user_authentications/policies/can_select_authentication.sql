-- Verify schemas/auth_public/tables/user_authentications/policies/can_select_authentication  on pg

BEGIN;

SELECT verify_policy ('select_own', 'auth_public.user_authentications');

SELECT has_table_privilege('authenticated', 'auth_public.user_authentications', 'SELECT');

ROLLBACK;
