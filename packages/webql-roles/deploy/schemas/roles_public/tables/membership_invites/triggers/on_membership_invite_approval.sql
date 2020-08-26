-- Deploy schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_approval to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/roles_public/tables/role_profiles/table

BEGIN;

CREATE FUNCTION roles_private.tg_on_membership_invite_approval ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
BEGIN
  -- RLS checks the rest, we only need to check that it is not the invitee that changes this prop
  IF (v_current_role_id = NEW.role_id) THEN
    RAISE
    EXCEPTION 'INVITES_ONLY_ADMIN_APPROVE';
  END IF;

  IF (NEW.approved AND NOT NEW.accepted) THEN
     NEW.invite_token = encode( gen_random_bytes( 32 ), 'hex' );
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

CREATE TRIGGER on_invite_approval
  BEFORE UPDATE ON roles_public.membership_invites
  FOR EACH ROW
  WHEN (NEW.approved IS DISTINCT FROM OLD.approved)
  EXECUTE PROCEDURE roles_private.tg_on_membership_invite_approval ();

COMMIT;

