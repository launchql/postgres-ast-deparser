-- Deploy schemas/status_private/procedures/user_incompleted_task to pg
-- requires: schemas/status_private/schema
-- requires: schemas/status_public/tables/user_task_achievement/table
-- requires: schemas/status_public/tables/user_task/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;
CREATE FUNCTION status_private.user_incompleted_task (
  task citext,
  role_id uuid DEFAULT roles_public.current_role_id ()
)
  RETURNS void
  AS $$
  DELETE FROM status_public.user_task_achievement
  WHERE user_id = role_id
    AND task_id = (
      SELECT
        t.id
      FROM
        status_public.user_task t
      WHERE
        name = task);
$$
LANGUAGE 'sql'
VOLATILE
SECURITY DEFINER;  -- because no rls yet
COMMIT;

