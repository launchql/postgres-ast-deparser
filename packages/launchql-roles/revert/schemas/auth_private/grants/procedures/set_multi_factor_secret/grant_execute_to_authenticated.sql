-- Revert schemas/auth_private/grants/procedures/set_multi_factor_secret/grant_execute_to_authenticated from pg

BEGIN;

REVOKE EXECUTE ON auth_private.set_multi_factor_secret FROM authenticated;

COMMIT;
