-- Verify schemas/status_public/tables/user_task_achievement/policies/user_task_achievement_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_user_task_achievement', 'status_public.user_task_achievement');
SELECT verify_policy ('can_insert_user_task_achievement', 'status_public.user_task_achievement');
SELECT verify_policy ('can_update_user_task_achievement', 'status_public.user_task_achievement');
SELECT verify_policy ('can_delete_user_task_achievement', 'status_public.user_task_achievement');

SELECT has_table_privilege('authenticated', 'status_public.user_task_achievement', 'INSERT');
SELECT has_table_privilege('authenticated', 'status_public.user_task_achievement', 'SELECT');
SELECT has_table_privilege('authenticated', 'status_public.user_task_achievement', 'UPDATE');
SELECT has_table_privilege('authenticated', 'status_public.user_task_achievement', 'DELETE');

ROLLBACK;
