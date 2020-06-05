-- Deploy schemas/roles_public/tables/membership_invites/triggers/on_membership_invite_created to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/membership_invites/table
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/roles_private/procedures/authorization/is_owner_of
-- requires: schemas/roles_private/procedures/authorization/is_admin_of
BEGIN;

CREATE FUNCTION roles_private.tg_on_membership_invite_created ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_role_id uuid;
  v_email email;
  v_sender_id uuid = roles_public.current_role_id ();
  v_approved boolean = FALSE;
  v_organization_id uuid;
  v_group roles_public.roles;
  v_profile permissions_public.profile;
  v_is_admin boolean;
  v_is_owner boolean;
BEGIN
  IF (NEW.role_id IS NOT NULL) THEN
    v_role_id = NEW.role_id;
  ELSIF (NEW.email IS NOT NULL) THEN
    v_email = NEW.email;
    SELECT
      e.role_id
    FROM
      roles_public.user_emails e
    WHERE
      e.email = NEW.email
      AND e.is_verified = TRUE INTO v_role_id;
    IF (v_role_id IS NOT NULL) THEN
      v_email = NULL;
    END IF;
  ELSE
    RAISE
    EXCEPTION 'INVITES_NO_INVITEE';
  END IF;
  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = NEW.group_id INTO v_group;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'INVITES_GROUP_NOT_FOUND';
  END IF;
  -- sanitize organization_id
  IF (v_group.type = 'User'::roles_public.role_type) THEN
    v_organization_id = v_group.id;
  ELSIF (v_group.type = 'Team'::roles_public.role_type) THEN
    v_organization_id = v_group.organization_id;
  ELSIF (v_group.type = 'Organization'::roles_public.role_type) THEN
    v_organization_id = v_group.id;
  END IF;
  -- check admin can only invite admin
  
  v_is_admin = roles_private.is_admin_of (v_sender_id,
    NEW.group_id);

  v_is_owner = roles_private.is_owner_of (v_sender_id,
    NEW.group_id);

  IF (NEW.profile_id IS NOT NULL) THEN
    SELECT * FROM permissions_public.profile 
    WHERE id = NEW.profile_id 
    AND organization_id = v_organization_id
    INTO v_profile;

    IF (NOT FOUND) THEN
      RAISE EXCEPTION 'INVITES_BAD_PROFILE_ID';
    END IF;

  END IF;

  IF (v_profile.name = 'Owner' AND NOT v_is_owner) THEN
    RAISE EXCEPTION 'INVITES_ONLY_OWNER_INVITE_OWNER';
  END IF;

  IF (v_profile.name = 'Administrator' AND NOT v_is_admin) THEN
    RAISE EXCEPTION 'INVITES_ONLY_ADMIN_INVITE_ADMIN';
  END IF;

  -- approvals automatic for admins
  IF (v_is_admin) THEN
    v_approved = TRUE;
  END IF;

  NEW.role_id = v_role_id;
  NEW.email = v_email;
  NEW.sender_id = v_sender_id;
  NEW.approved = v_approved;
  NEW.organization_id = v_organization_id;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

CREATE TRIGGER on_invite_created
  BEFORE INSERT ON roles_public.membership_invites
  FOR EACH ROW
  EXECUTE PROCEDURE roles_private.tg_on_membership_invite_created ();

COMMIT;

