-- Deploy schemas/roles_public/tables/user_emails/triggers/after_is_verified_set_achievement to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/status_private/procedures/user_completed_task

BEGIN;



CREATE FUNCTION roles_private.tg_after_is_verified_set_achievement()
RETURNS TRIGGER AS $$
BEGIN
  IF (NEW.is_verified) THEN
    PERFORM status_private.user_completed_task('verify_email', NEW.role_id);
  END IF;
 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER after_is_verified_set_achievement_insert
AFTER INSERT ON roles_public.user_emails
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_after_is_verified_set_achievement ();

CREATE TRIGGER after_is_verified_set_achievement_update
AFTER UPDATE ON roles_public.user_emails
FOR EACH ROW
WHEN (NEW.is_verified IS DISTINCT FROM OLD.is_verified)
EXECUTE PROCEDURE roles_private.tg_after_is_verified_set_achievement ();

COMMIT;
