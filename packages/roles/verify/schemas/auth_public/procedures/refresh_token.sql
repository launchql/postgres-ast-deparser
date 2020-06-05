-- Verify schemas/auth_public/procedures/refresh_token  on pg

BEGIN;

SELECT verify_function ('auth_public.refresh_token', current_user);

ROLLBACK;
