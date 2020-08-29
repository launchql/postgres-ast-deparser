-- Revert schemas/roles_public/grants/procedures/current_role/grant_execute_to_anonymous_authenticated from pg

BEGIN;

REVOKE EXECUTE ON FUNCTION roles_public.current_role FROM anonymous;
REVOKE EXECUTE ON FUNCTION roles_public.current_role FROM authenticated;

COMMIT;
