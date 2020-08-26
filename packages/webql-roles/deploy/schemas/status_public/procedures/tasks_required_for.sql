-- Deploy schemas/status_public/procedures/tasks_required_for to pg
-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_task/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/status_public/tables/user_achievement/table

BEGIN;

CREATE FUNCTION status_public.tasks_required_for (
  achievement citext,
  role_id uuid DEFAULT roles_public.current_role_id ()
)
  RETURNS SETOF status_public.user_task
  AS $$
BEGIN
  RETURN QUERY
    SELECT
      t.*
    FROM
      status_public.user_task t
    FULL OUTER JOIN status_public.user_task_achievement u ON (
      u.task_id = t.id
      AND u.user_id = role_id
    )
    JOIN status_public.user_achievement f ON (t.achievement_id = f.id)
  WHERE
    u.user_id IS NULL
    AND f.name = achievement
  ORDER BY t.priority ASC
;
END;
$$
LANGUAGE 'plpgsql'
STABLE;
COMMIT;

