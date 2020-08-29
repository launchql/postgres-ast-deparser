-- Revert schemas/roles_public/tables/role_profiles/triggers/on_update_display_name_set_achievement from pg

BEGIN;

DROP TRIGGER on_update_display_name_set_achievement ON roles_public.role_profiles;
DROP TRIGGER on_insert_display_name_set_achievement ON roles_public.role_profiles;
DROP FUNCTION roles_private.tg_on_update_display_name_set_achievement; 

COMMIT;
