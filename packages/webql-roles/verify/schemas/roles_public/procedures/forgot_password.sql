-- Verify schemas/roles_public/procedures/forgot_password  on pg

BEGIN;

SELECT verify_function ('roles_public.forgot_password', current_user);

ROLLBACK;
