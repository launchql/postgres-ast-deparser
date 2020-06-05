-- Verify schemas/auth_public/tables/user_authentications/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM auth_public.user_authentications LIMIT 1;
SELECT updated_at FROM auth_public.user_authentications LIMIT 1;
SELECT verify_trigger ('auth_public.update_auth_public_user_authentications_modtime');

ROLLBACK;
