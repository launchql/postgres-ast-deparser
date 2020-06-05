-- Revert schemas/status_public/tables/user_task_achievement/table from pg

BEGIN;

DROP TABLE status_public.user_feature_task;

COMMIT;
