-- Verify schemas/roles_public/tables/user_emails/table on pg

BEGIN;

SELECT verify_table ('roles_public.user_emails');

ROLLBACK;
