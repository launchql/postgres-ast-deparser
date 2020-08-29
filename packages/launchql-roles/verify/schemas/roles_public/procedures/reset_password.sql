-- Verify schemas/roles_public/procedures/reset_password  on pg

BEGIN;

SELECT verify_function ('roles_public.reset_password', current_user);

ROLLBACK;
