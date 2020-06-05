-- Verify schemas/roles_public/tables/roles/triggers/on_update_username_set_achievement  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_update_username_set_achievement'); 
SELECT verify_trigger ('roles_public.on_update_username_set_achievement');
SELECT verify_trigger ('roles_public.on_insert_username_set_achievement');

ROLLBACK;
