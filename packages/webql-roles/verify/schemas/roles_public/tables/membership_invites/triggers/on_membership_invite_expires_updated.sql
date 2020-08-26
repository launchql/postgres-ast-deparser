-- Verify schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_expires_updated  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_invite_expires_updated'); 
SELECT verify_trigger ('roles_public.on_invite_expires_updated');

ROLLBACK;
