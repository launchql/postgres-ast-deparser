-- Verify schemas/status_public/tables/user_task_achievement/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('status_public.user_task_achievement');

ROLLBACK;
