-- Verify schemas/roles_public/tables/user_emails/policies/enable_row_level_security on pg

BEGIN;

SELECT verify_security ('roles_public.user_emails');

ROLLBACK;
