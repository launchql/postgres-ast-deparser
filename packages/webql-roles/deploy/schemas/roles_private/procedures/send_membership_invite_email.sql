-- Deploy schemas/roles_private/procedures/send_membership_invite_email to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/role_profiles/table
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/membership_invites/table

BEGIN;

CREATE FUNCTION roles_private.send_membership_invite_email(
  invite_id uuid
) returns void as $$
DECLARE
  v_invite roles_public.membership_invites;
  v_group_role roles_public.roles;
  v_group roles_public.role_profiles;
  v_inviter roles_public.role_profiles;
BEGIN

  SELECT * FROM roles_public.membership_invites
  INTO v_invite
  WHERE id=invite_id;

  SELECT * FROM roles_public.role_profiles
  INTO v_inviter
  WHERE role_id=v_invite.sender_id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.role_profiles
  INTO v_group
  WHERE role_id=v_invite.group_id;

  SELECT * FROM roles_public.roles
  INTO v_group_role
  WHERE id=v_invite.group_id;

  PERFORM
    app_jobs.add_job ('membership__invite_member_email',
      json_build_object(
        'type', v_group_role.type::text,
        'email', v_invite.email::text,
        'inviter_name', v_inviter.display_name::text,
        'group_name', v_group.display_name::text,
        'invite_token', v_invite.invite_token::text
      ));
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

COMMIT;
