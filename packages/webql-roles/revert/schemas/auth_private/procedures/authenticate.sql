-- Revert schemas/auth_private/procedures/authenticate from pg

BEGIN;

DROP FUNCTION auth_private.authenticate;

COMMIT;
