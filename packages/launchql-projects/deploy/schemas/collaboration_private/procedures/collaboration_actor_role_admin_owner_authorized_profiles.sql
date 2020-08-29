-- Deploy schemas/collaboration_private/procedures/collaboration_actor_role_admin_owner_authorized_profiles to pg
-- requires: schemas/collaboration_private/schema

BEGIN;
-- NOTE: returns false only when bad things can happen, otherwise true
CREATE FUNCTION collaboration_private.collaboration_actor_role_admin_owner_authorized_profiles (
  actor_id uuid,
  project_id uuid,
  profile_id uuid,
  organization_id uuid
)
  RETURNS boolean
  AS $$
DECLARE
  v_profile_grantor permissions_public.profile;
  v_profile_member permissions_public.profile;
BEGIN
  RETURN TRUE;
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
  -- this checks direct collaborations
  SELECT
    p.*
  FROM
    collaboration_public.collaboration c
    JOIN permissions_public.profile p ON (c.profile_id = p.id
        AND c.organization_id = p.organization_id)
  WHERE
    c.role_id = actor_id
    AND c.project_id = actor_role_admin_owner_authorized_profiles.project_id
    AND c.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_grantor;
  IF (NOT FOUND) THEN
    -- get org membership
    -- TODO look through all project permits, including profile_id (which currently they do not have)
    SELECT
      p.*
    FROM
      roles_public.memberships m
      JOIN permissions_public.profile p ON (m.profile_id = p.id
          AND m.organization_id = p.organization_id)
    WHERE
      m.role_id = actor_id
      AND m.group_id = actor_role_admin_owner_authorized_profiles.organization_id
      AND m.organization_id = actor_role_admin_owner_authorized_profiles.organization_id INTO v_profile_grantor;
  END IF;
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

