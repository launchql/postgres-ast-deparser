-- Revert schemas/auth_private/tables/user_authentication_secrets/table from pg

BEGIN;

DROP TABLE auth_private.user_authentication_secrets;

COMMIT;
