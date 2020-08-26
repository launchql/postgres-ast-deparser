-- Revert schemas/roles_public/tables/roles/triggers/on_update_username_set_achievement from pg

BEGIN;

DROP TRIGGER on_insert_username_set_achievement ON roles_public.roles;
DROP TRIGGER on_update_username_set_achievement ON roles_public.roles;
DROP FUNCTION roles_private.tg_on_update_username_set_achievement; 

COMMIT;
