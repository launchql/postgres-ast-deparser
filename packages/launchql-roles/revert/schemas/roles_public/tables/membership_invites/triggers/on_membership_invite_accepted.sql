-- Revert schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_accepted from pg

BEGIN;

DROP TRIGGER on_invite_accepted ON roles_public.membership_invites;
DROP FUNCTION roles_private.tg_on_invite_accepted; 

COMMIT;
