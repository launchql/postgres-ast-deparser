-- Deploy schemas/roles_private/procedures/actor_role_admin_owner_authorized_profiles to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;
-- NOTE: returns FALSE only when profiles are found to be Admin/Owner and actor is not powerful enough
CREATE FUNCTION roles_private.actor_role_admin_owner_authorized_profiles (
  actor_id uuid,
  group_id uuid,
  profile_id uuid,
  organization_id uuid
)
  RETURNS boolean
  AS $$
DECLARE
  v_profile_grantor permissions_public.profile;
  v_profile_member permissions_public.profile;
BEGIN
  SELECT
    p.*
  FROM
    permissions_public.profile p
  WHERE
    p.id = actor_role_admin_owner_authorized_profiles.profile_id
    AND p.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_member;
  IF (NOT FOUND) THEN
    RETURN TRUE;
  END IF;
  SELECT
    p.*
  FROM
    roles_public.memberships m
    JOIN permissions_public.profile p ON (m.profile_id = p.id
        AND m.organization_id = p.organization_id)
  WHERE
    m.role_id = actor_id
    AND m.group_id = actor_role_admin_owner_authorized_profiles.group_id
    AND m.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_grantor;
  -- Now check profiles
  IF (v_profile_member.name = 'Administrator') THEN
    IF (v_profile_grantor.name = 'Administrator' OR v_profile_grantor.name = 'Owner') THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END IF;
  IF (v_profile_member.name = 'Owner') THEN
    IF (v_profile_grantor.name = 'Owner') THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END IF;
  RETURN TRUE;
END;
$$
LANGUAGE 'plpgsql'
STABLE
SECURITY DEFINER;
COMMIT;

