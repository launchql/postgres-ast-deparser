-- Verify schemas/status_public/tables/user_task_achievement/indexes/user_id_idx  on pg

BEGIN;

SELECT verify_index ('status_public.user_task_achievement', 'user_id_idx');

ROLLBACK;
