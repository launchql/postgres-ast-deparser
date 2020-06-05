-- Deploy schemas/status_private/procedures/user_completed_task to pg
-- requires: schemas/status_private/schema
-- requires: schemas/status_public/tables/user_task_achievement/table
-- requires: schemas/status_public/tables/user_task/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;
CREATE FUNCTION status_private.user_completed_task (
  task citext,
  role_id uuid DEFAULT roles_public.current_role_id ()
)
  RETURNS void
  AS $$
  INSERT INTO status_public.user_task_achievement (user_id, task_id)
  VALUES (role_id, (
      SELECT
        t.id
      FROM
        status_public.user_task t
      WHERE
        name = task));
$$
LANGUAGE 'sql'
VOLATILE
SECURITY DEFINER; -- because no rls yet
COMMIT;

