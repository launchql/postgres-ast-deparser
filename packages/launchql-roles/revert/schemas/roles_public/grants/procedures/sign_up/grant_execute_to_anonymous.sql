-- Revert schemas/roles_public/grants/procedures/sign_up/grant_execute_to_anonymous from pg

BEGIN;

REVOKE EXECUTE ON FUNCTION roles_public.sign_up FROM anonymous;

COMMIT;
