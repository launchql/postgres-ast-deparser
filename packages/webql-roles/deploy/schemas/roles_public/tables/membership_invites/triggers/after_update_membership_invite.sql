-- Deploy schemas/roles_public/tables/membership_invites/triggers/after_update_membership_invite to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_private/procedures/send_membership_invite_email

BEGIN;



CREATE FUNCTION roles_private.tg_after_update_membership_invite()
RETURNS TRIGGER AS $$
BEGIN

  IF (NEW.approved AND NOT NEW.accepted) THEN
    PERFORM roles_private.send_membership_invite_email(NEW.id);
  END IF;

 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER after_update_membership_invite
AFTER UPDATE ON roles_public.membership_invites
FOR EACH ROW
WHEN (NEW.approved IS DISTINCT FROM OLD.approved)
EXECUTE PROCEDURE roles_private.tg_after_update_membership_invite ();

COMMIT;
