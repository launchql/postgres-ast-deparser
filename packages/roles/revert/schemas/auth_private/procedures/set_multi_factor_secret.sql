-- Revert schemas/auth_private/procedures/set_multi_factor_secret from pg

BEGIN;

DROP FUNCTION auth_private.set_multi_factor_secret;

COMMIT;
