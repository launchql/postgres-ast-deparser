-- Verify schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_accepted  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_invite_accepted', current_user); 
SELECT verify_trigger ('roles_private.on_invite_accepted');

ROLLBACK;
