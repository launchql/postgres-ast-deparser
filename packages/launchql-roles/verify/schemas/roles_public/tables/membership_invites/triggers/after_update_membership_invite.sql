-- Verify schemas/roles_public/tables/membership_invites/triggers/after_update_membership_invite  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_after_update_membership_invite'); 
SELECT verify_trigger ('roles_public.after_update_membership_invite');

ROLLBACK;
