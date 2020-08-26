-- Verify schemas/roles_public/tables/role_profiles/triggers/on_update_display_name_set_achievement  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_update_display_name_set_achievement'); 
SELECT verify_trigger ('roles_public.on_update_display_name_set_achievement');
SELECT verify_trigger ('roles_public.on_insert_display_name_set_achievement');

ROLLBACK;
