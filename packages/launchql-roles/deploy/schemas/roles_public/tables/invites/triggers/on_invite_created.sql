-- Deploy schemas/roles_public/tables/invites/triggers/on_invite_created to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/invites/table
-- requires: schemas/roles_public/tables/role_profiles/table

BEGIN;
CREATE FUNCTION roles_private.tg_on_invite_created ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_current_role_id uuid = roles_public.current_role_id ();
  v_inviter_profile roles_public.role_profiles;
BEGIN
  SELECT
    *
  FROM
    roles_public.role_profiles INTO v_inviter_profile
  WHERE
    role_id = v_current_role_id;
  PERFORM
    app_jobs.add_job ('invites__invite_email',
      json_build_object('inviter_name', v_inviter_profile.display_name, 'email', NEW.email::text, 'invite_token', NEW.invite_token::text));
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;
CREATE TRIGGER on_invite_created
  AFTER INSERT ON roles_public.invites
  FOR EACH ROW
  EXECUTE PROCEDURE roles_private.tg_on_invite_created ();
COMMIT;

