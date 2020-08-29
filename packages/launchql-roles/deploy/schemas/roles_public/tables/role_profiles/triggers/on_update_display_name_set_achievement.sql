-- Deploy schemas/roles_public/tables/role_profiles/triggers/on_update_display_name_set_achievement to pg
-- requires: schemas/roles_public/schema

-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type

-- requires: schemas/roles_public/tables/role_profiles/table
-- requires: schemas/status_private/procedures/user_incompleted_task
-- requires: schemas/status_private/procedures/user_completed_task

BEGIN;
CREATE FUNCTION roles_private.tg_on_update_display_name_set_achievement ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_role_type roles_public.role_type;
BEGIN
  SELECT type 
    FROM roles_public.roles
    WHERE id = NEW.role_id
    INTO v_role_type;

  IF (v_role_type != 'User'::roles_public.role_type) THEN
    RETURN NEW;
  END IF;

  IF (NEW.display_name IS NULL) THEN
    PERFORM status_private.user_incompleted_task('create_display_name', NEW.role_id);
  ELSE
    PERFORM status_private.user_completed_task('create_display_name', NEW.role_id);
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;

CREATE TRIGGER on_insert_display_name_set_achievement
  AFTER INSERT ON roles_public.role_profiles
  FOR EACH ROW
  EXECUTE PROCEDURE roles_private.tg_on_update_display_name_set_achievement ();

CREATE TRIGGER on_update_display_name_set_achievement
  AFTER UPDATE ON roles_public.role_profiles
  FOR EACH ROW
  WHEN (NEW.display_name IS DISTINCT FROM OLD.display_name)
  EXECUTE PROCEDURE roles_private.tg_on_update_display_name_set_achievement ();

COMMIT;

