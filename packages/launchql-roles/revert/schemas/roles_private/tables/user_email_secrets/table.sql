-- Revert schemas/roles_private/tables/user_email_secrets/table from pg

BEGIN;

DROP TABLE roles_private.user_email_secrets;

COMMIT;
