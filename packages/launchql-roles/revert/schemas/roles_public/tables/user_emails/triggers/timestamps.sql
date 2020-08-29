-- Revert schemas/roles_public/tables/user_emails/triggers/timestamps from pg

BEGIN;

ALTER TABLE roles_public.user_emails DROP COLUMN created_at;
ALTER TABLE roles_public.user_emails DROP COLUMN updated_at;
DROP TRIGGER update_roles_public_user_emails_modtime ON roles_public.user_emails;

COMMIT;
