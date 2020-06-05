-- Verify schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_created  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_invite_created', current_user); 
SELECT verify_trigger ('roles_public.on_invite_created');

ROLLBACK;
