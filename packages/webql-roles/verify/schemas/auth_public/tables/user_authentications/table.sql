-- Verify schemas/auth_public/tables/user_authentications/table on pg

BEGIN;

SELECT verify_table ('auth_public.user_authentications');

ROLLBACK;
