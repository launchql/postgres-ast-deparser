-- Deploy schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_accepted to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

CREATE FUNCTION roles_private.tg_on_membership_invite_accepted ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
BEGIN
  IF (NEW.role_id IS NULL) THEN
    RAISE
    EXCEPTION 'INVITES_ONLY_ACCEPT_AFTER_ACCOUNT';
  END IF;
  IF (v_current_role_id != NEW.role_id) THEN
    RAISE
    EXCEPTION 'INVITES_ONLY_INVITEE_ACCEPT';
  END IF;
  IF (NEW.approved AND NEW.accepted) THEN
    INSERT INTO roles_public.memberships (role_id, group_id, profile_id, organization_id, invited_by_id)
      VALUES (NEW.role_id, NEW.group_id, NEW.profile_id, NEW.organization_id, NEW.sender_id);
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

CREATE TRIGGER on_invite_accepted
  BEFORE UPDATE ON roles_public.membership_invites
  FOR EACH ROW
  WHEN (NEW.accepted IS DISTINCT FROM OLD.accepted)
  EXECUTE PROCEDURE roles_private.tg_on_membership_invite_accepted ();

COMMIT;
