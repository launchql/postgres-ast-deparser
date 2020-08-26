-- Revert schemas/roles_public/tables/membership_invites/triggers/after_update_membership_invite from pg

BEGIN;

DROP TRIGGER after_update_membership_invite ON roles_public.membership_invites;
DROP FUNCTION roles_private.tg_after_update_membership_invite; 

COMMIT;
