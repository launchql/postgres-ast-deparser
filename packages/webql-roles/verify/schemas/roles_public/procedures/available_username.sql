-- Verify schemas/roles_public/procedures/available_username  on pg

BEGIN;

SELECT verify_function ('roles_public.available_username', current_user);

ROLLBACK;
