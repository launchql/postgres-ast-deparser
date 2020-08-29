-- Revert schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_expires_updated from pg

BEGIN;

DROP TRIGGER on_invite_expires_updated ON roles_public.membership_invites;
DROP FUNCTION roles_private.tg_on_invite_expires_updated; 

COMMIT;
