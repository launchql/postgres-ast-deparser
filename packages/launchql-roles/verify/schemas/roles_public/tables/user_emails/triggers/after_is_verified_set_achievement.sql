-- Verify schemas/roles_public/tables/user_emails/triggers/after_is_verified_set_achievement  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_after_is_verified_set_achievement'); 
SELECT verify_trigger ('roles_public.after_is_verified_set_achievement_insert');
SELECT verify_trigger ('roles_public.after_is_verified_set_achievement_update');

ROLLBACK;
