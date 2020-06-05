-- Revert schemas/roles_public/grants/procedures/current_role_id/grant_execute_to_authenticated from pg

BEGIN;

REVOKE EXECUTE ON FUNCTION roles_public.current_role_id FROM authenticated;

COMMIT;
