-- Revert schemas/auth_private/grants/procedures/authenticate/grant_execute_to_anonymous from pg

BEGIN;

REVOKE EXECUTE ON auth_private.authenticate FROM anonymous;

COMMIT;
