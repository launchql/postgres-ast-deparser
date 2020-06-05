-- Verify schemas/status_public/tables/user_task_achievement/table on pg

BEGIN;

SELECT verify_table ('status_public.user_feature_task');

ROLLBACK;
