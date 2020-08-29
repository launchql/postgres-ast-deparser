-- Revert schemas/auth_private/procedures/multi_factor_auth from pg

BEGIN;

DROP FUNCTION auth_private.multi_factor_auth;

COMMIT;
