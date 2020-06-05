-- Verify schemas/status_public/tables/user_task_achievement/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM status_public.user_task_achievement LIMIT 1;
SELECT updated_at FROM status_public.user_task_achievement LIMIT 1;
SELECT verify_trigger ('status_public.update_status_public_user_task_achievement_modtime');

ROLLBACK;
