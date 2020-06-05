-- Revert schemas/roles_public/tables/invites/triggers/on_invite_created from pg

BEGIN;

DROP TRIGGER on_invite_created ON roles_public.invites;
DROP FUNCTION roles_private.tg_on_invite_created; 

COMMIT;
