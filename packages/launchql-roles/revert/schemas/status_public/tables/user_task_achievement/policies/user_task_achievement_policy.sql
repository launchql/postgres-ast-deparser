-- Revert schemas/status_public/tables/user_task_achievement/policies/user_task_achievement_policy from pg

BEGIN;


REVOKE INSERT ON TABLE status_public.user_task_achievement FROM authenticated;
REVOKE SELECT ON TABLE status_public.user_task_achievement FROM authenticated;
REVOKE UPDATE ON TABLE status_public.user_task_achievement FROM authenticated;
REVOKE DELETE ON TABLE status_public.user_task_achievement FROM authenticated;

DROP POLICY can_select_user_task_achievement ON status_public.user_task_achievement;
DROP POLICY can_insert_user_task_achievement ON status_public.user_task_achievement;
DROP POLICY can_update_user_task_achievement ON status_public.user_task_achievement;
DROP POLICY can_delete_user_task_achievement ON status_public.user_task_achievement;

COMMIT;
