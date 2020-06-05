-- Deploy schemas/roles_public/tables/user_emails/triggers/timestamps to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table

BEGIN;

ALTER TABLE roles_public.user_emails ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE roles_public.user_emails ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE roles_public.user_emails ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE roles_public.user_emails ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_roles_public_user_emails_modtime
BEFORE UPDATE OR INSERT ON roles_public.user_emails
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
