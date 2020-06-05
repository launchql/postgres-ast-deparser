-- Deploy schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_expires_updated to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

CREATE FUNCTION roles_private.tg_on_invite_expires_updated ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
BEGIN
  -- RLS checks the rest, we only need to check that it is not the invitee that changes this prop
  IF (v_current_role_id = NEW.role_id) THEN
    RAISE EXCEPTION 'INVITES_ONLY_MEMBERS_CHANGE_EXPIRY';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;

CREATE TRIGGER on_invite_expires_updated
  BEFORE UPDATE ON roles_public.membership_invites
  FOR EACH ROW
  WHEN (NEW.expires_at IS DISTINCT FROM OLD.expires_at)
  EXECUTE PROCEDURE roles_private.tg_on_invite_expires_updated ();

COMMIT;

