-- Revert schemas/roles_public/tables/membership_invites/triggers/invite_member_email from pg

BEGIN;

DROP TRIGGER invite_member_email ON roles_public.membership_invites;
DROP FUNCTION roles_private.invite_member_email_fn;

COMMIT;
