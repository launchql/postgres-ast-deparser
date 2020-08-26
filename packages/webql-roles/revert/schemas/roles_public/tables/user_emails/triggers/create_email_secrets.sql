-- Revert schemas/roles_public/tables/user_emails/triggers/create_email_secrets from pg

BEGIN;

DROP TRIGGER create_email_secrets ON roles_public.user_emails;
DROP FUNCTION roles_private.tg_create_email_secrets; 

COMMIT;
