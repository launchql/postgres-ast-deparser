-- Verify schemas/roles_public/grants/procedures/current_role_id/grant_execute_to_authenticated on pg

BEGIN;

SELECT verify_function ('roles_public.current_role_id', 'authenticated');

ROLLBACK;
