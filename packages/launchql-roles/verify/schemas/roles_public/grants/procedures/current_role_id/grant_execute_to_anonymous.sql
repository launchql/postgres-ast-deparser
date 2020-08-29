-- Verify schemas/roles_public/grants/procedures/current_role_id/grant_execute_to_anonymous on pg

BEGIN;

SELECT verify_function ('roles_public.current_role_id', 'anonymous');

ROLLBACK;
