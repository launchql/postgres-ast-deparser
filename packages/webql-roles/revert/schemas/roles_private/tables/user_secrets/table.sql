-- Revert schemas/roles_private/tables/user_secrets/table from pg

BEGIN;

DROP TABLE roles_private.user_secrets;

COMMIT;
