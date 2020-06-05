-- Revert schemas/auth_private/tables/token/table from pg

BEGIN;

DROP TABLE auth_private.token;

COMMIT;
