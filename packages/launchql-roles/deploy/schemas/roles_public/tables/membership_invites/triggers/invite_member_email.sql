-- Deploy schemas/roles_public/tables/membership_invites/triggers/invite_member_email to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_private/procedures/send_membership_invite_email
-- requires: schemas/roles_private/procedures/send_membership_invite_approval_email 

BEGIN;

CREATE FUNCTION roles_private.invite_member_email_fn () RETURNS TRIGGER AS
$$
BEGIN

  IF (NEW.approved AND NOT NEW.accepted) THEN
    PERFORM roles_private.send_membership_invite_email(NEW.id);
  ELSIF (NOT NEW.approved) THEN
    PERFORM roles_private.send_membership_invite_approval_email(NEW.id);
  END IF;

  RETURN NEW;

END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER invite_member_email
AFTER INSERT ON roles_public.membership_invites
FOR EACH ROW EXECUTE PROCEDURE roles_private.invite_member_email_fn ();

COMMIT;
