-- Deploy schemas/roles_private/procedures/send_membership_invite_approval_email to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/role_profiles/table
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/membership_invites/table
-- requries: schemas/roles_public/tables/memberships/table
-- requires: schemas/permissions_public/tables/profile/table


BEGIN;

CREATE FUNCTION roles_private.send_membership_invite_approval_email(
  invite_id uuid
) returns void as $$
DECLARE
  v_invite roles_public.membership_invites;
  v_group_role roles_public.roles;
  v_group roles_public.role_profiles;
  v_inviter roles_public.role_profiles;
  v_invitee roles_public.role_profiles;
  v_invitee_email text;
  v_admin_emails text;

BEGIN
  -- TODO get admin email

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

  IF (v_invite.role_id IS NOT NULL) THEN
    SELECT email FROM roles_public.user_emails e
      WHERE e.role_id=v_invite.role_id
      INTO v_invitee_email;
  ELSE
    v_invitee_email = v_invite.email;
  END IF;

  -- group managers/admins
  SELECT string_agg(distinct(e.email), ',')
  	FROM roles_public.memberships m
    JOIN roles_public.user_emails e ON m.role_id =e.role_id
    JOIN permissions_public.profile p ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
    WHERE 
        (p.name = 'Administrator' or p.name = 'Owner')
        AND m.group_id = v_group_role.id
    INTO v_admin_emails;

  PERFORM
    app_jobs.add_job ('membership__invite_member_approval_email',
      json_build_object(
        'type', v_group_role.type::text,
        'invitee_email', v_invitee_email,
        'admin_emails', v_admin_emails::text,
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
