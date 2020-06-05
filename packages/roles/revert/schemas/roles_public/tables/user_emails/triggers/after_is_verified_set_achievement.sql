-- Revert schemas/roles_public/tables/user_emails/triggers/after_is_verified_set_achievement from pg

BEGIN;

DROP TRIGGER after_is_verified_set_achievement_insert ON roles_public.user_emails;
DROP TRIGGER after_is_verified_set_achievement_update ON roles_public.user_emails;
DROP FUNCTION roles_private.tg_after_is_verified_set_achievement; 

COMMIT;
