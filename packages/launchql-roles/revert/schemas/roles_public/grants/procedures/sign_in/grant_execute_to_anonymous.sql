-- Revert schemas/roles_public/grants/procedures/sign_in/grant_execute_to_anonymous from pg

BEGIN;

REVOKE EXECUTE ON FUNCTION roles_public.sign_in FROM anonymous;

COMMIT;
