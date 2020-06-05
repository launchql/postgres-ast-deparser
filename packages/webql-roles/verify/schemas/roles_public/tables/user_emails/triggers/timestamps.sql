-- Verify schemas/roles_public/tables/user_emails/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM roles_public.user_emails LIMIT 1;
SELECT updated_at FROM roles_public.user_emails LIMIT 1;
SELECT verify_trigger ('roles_public.update_roles_public_user_emails_modtime');

ROLLBACK;
