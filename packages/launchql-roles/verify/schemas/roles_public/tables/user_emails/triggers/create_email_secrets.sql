-- Verify schemas/roles_public/tables/user_emails/triggers/create_email_secrets  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_create_email_secrets'); 
SELECT verify_trigger ('roles_public.create_email_secrets');

ROLLBACK;
