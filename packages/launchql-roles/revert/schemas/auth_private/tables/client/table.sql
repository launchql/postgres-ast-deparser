-- Revert schemas/auth_private/tables/client/table from pg

BEGIN;

DROP TABLE auth_private.client;

COMMIT;
