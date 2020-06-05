-- Verify schemas/roles_public/tables/invites/triggers/on_invite_created  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_invite_created'); 
SELECT verify_trigger ('roles_public.on_invite_created');

ROLLBACK;
