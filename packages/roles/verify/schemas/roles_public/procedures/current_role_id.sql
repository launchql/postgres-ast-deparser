-- Verify schemas/roles_public/procedures/current_role_id  on pg

BEGIN;

SELECT verify_function ('roles_public.current_role_id', current_user);

ROLLBACK;
