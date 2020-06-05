-- Verify schemas/roles_public/procedures/set_password  on pg

BEGIN;

SELECT verify_function ('roles_public.set_password');

ROLLBACK;
