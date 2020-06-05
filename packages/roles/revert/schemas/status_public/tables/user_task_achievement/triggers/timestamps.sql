-- Revert schemas/status_public/tables/user_task_achievement/triggers/timestamps from pg

BEGIN;

ALTER TABLE status_public.user_task_achievement DROP COLUMN created_at;
ALTER TABLE status_public.user_task_achievement DROP COLUMN updated_at;
DROP TRIGGER update_status_public_user_task_achievement_modtime ON status_public.user_task_achievement;

COMMIT;
