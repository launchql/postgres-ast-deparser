-- Deploy schemas/roles_public/tables/user_emails/triggers/convert_invites_to_role_id to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

-- TODO move this to the membership_invites

CREATE FUNCTION roles_public.tg_convert_invites_to_role_id()
RETURNS TRIGGER AS $$
BEGIN

  IF (NEW.is_verified) THEN
    UPDATE roles_public.membership_invites invites
    SET role_id=NEW.role_id
    WHERE invites.email=NEW.email;
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER convert_invites_to_role_id_after_insert
AFTER INSERT ON roles_public.user_emails
FOR EACH ROW
EXECUTE PROCEDURE roles_public.tg_convert_invites_to_role_id ();

CREATE TRIGGER convert_invites_to_role_id_after_update
AFTER UPDATE ON roles_public.user_emails
FOR EACH ROW
WHEN (NEW.is_verified IS DISTINCT FROM OLD.is_verified)
EXECUTE PROCEDURE roles_public.tg_convert_invites_to_role_id ();

COMMIT;
