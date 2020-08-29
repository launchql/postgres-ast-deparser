-- Deploy schemas/roles_public/tables/roles/triggers/on_update_username_set_achievement to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/status_private/procedures/user_completed_task
-- requires: schemas/status_private/procedures/user_incompleted_task
-- requires: schemas/roles_public/types/role_type

BEGIN;

CREATE FUNCTION roles_private.tg_on_update_username_set_achievement()
RETURNS TRIGGER AS $$
BEGIN
  IF (NEW.username IS NULL) THEN
    PERFORM status_private.user_incompleted_task('create_username', NEW.id);
  ELSE
    PERFORM status_private.user_completed_task('create_username', NEW.id);
  END IF;
 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER on_update_username_set_achievement
AFTER UPDATE ON roles_public.roles
FOR EACH ROW
WHEN (NEW.username IS DISTINCT FROM OLD.username AND NEW.type = 'User'::roles_public.role_type)
EXECUTE PROCEDURE roles_private.tg_on_update_username_set_achievement ();

CREATE TRIGGER on_insert_username_set_achievement
AFTER INSERT ON roles_public.roles
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_on_update_username_set_achievement ();

COMMIT;
