-- Verify schemas/auth_public/tables/user_authentications/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('auth_public.user_authentications');

ROLLBACK;
