-- Deploy schemas/status_public/tables/user_task_achievement/policies/user_task_achievement_policy to pg
-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task_achievement/table
-- requires: schemas/status_public/tables/user_task_achievement/policies/enable_row_level_security
-- requries: schemas/roles_public/procedures/current_role_id

BEGIN;
CREATE POLICY can_select_user_task_achievement ON status_public.user_task_achievement
  FOR SELECT
    USING (roles_public.current_role_id () = user_id);
CREATE POLICY can_insert_user_task_achievement ON status_public.user_task_achievement
  FOR INSERT
    WITH CHECK (FALSE);
CREATE POLICY can_update_user_task_achievement ON status_public.user_task_achievement
  FOR UPDATE
    USING (FALSE);
CREATE POLICY can_delete_user_task_achievement ON status_public.user_task_achievement
  FOR DELETE
    USING (FALSE);

GRANT INSERT ON TABLE status_public.user_task_achievement TO authenticated;
GRANT SELECT ON TABLE status_public.user_task_achievement TO authenticated;
GRANT UPDATE ON TABLE status_public.user_task_achievement TO authenticated;
GRANT DELETE ON TABLE status_public.user_task_achievement TO authenticated;
COMMIT;

