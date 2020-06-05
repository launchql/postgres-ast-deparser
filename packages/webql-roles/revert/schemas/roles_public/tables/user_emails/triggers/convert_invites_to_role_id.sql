-- Revert schemas/roles_public/tables/user_emails/triggers/convert_invites_to_role_id from pg

BEGIN;

DROP TRIGGER convert_invites_to_role_id ON roles_public.user_emails;
DROP FUNCTION roles_public.tg_convert_invites_to_role_id; 

COMMIT;
