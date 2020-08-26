-- Revert schemas/auth_private/procedures/current_token from pg

BEGIN;

DROP FUNCTION auth_private.current_token;

COMMIT;
