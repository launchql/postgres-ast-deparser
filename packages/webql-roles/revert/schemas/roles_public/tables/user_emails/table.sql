-- Revert schemas/roles_public/tables/user_emails/table from pg

BEGIN;

DROP TABLE roles_public.user_emails;

COMMIT;
