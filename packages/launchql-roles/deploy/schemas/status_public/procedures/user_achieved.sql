-- Deploy schemas/status_public/procedures/user_achieved to pg

-- requires: schemas/status_public/schema
-- requires: schemas/status_public/tables/user_achievement/table
-- requires: schemas/status_public/tables/user_task/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

CREATE FUNCTION status_public.user_achieved(
  achievement citext,
  role_id uuid DEFAULT roles_public.current_role_id()

) returns boolean as $$
DECLARE
  v_achievement status_public.user_achievement;
  v_task status_public.user_task;
  v_value boolean = TRUE;
BEGIN
  SELECT * FROM status_public.user_achievement
    WHERE name = achievement
    INTO v_achievement;

  IF (NOT FOUND) THEN
    RETURN FALSE;
  END IF;

  FOR v_task IN
  SELECT * FROM
    status_public.user_task
    WHERE achievement_id = v_achievement.id
  LOOP

    SELECT EXISTS(
      SELECT 1
      FROM status_public.user_task_achievement
      WHERE 
        user_id = role_id
        AND task_id = v_task.id
    ) AND v_value
      INTO v_value;
    
  END LOOP;

  RETURN v_value;

END;
$$
LANGUAGE 'plpgsql' STABLE;

COMMIT;
