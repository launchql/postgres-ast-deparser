-- Deploy schemas/roles_private/triggers/tg_ensure_proper_membership to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type

BEGIN;

CREATE FUNCTION roles_private.tg_ensure_proper_membership()
RETURNS TRIGGER
AS $$
DECLARE
  grantee_role roles_public.roles;
  group_role roles_public.roles;
  v_organization_id uuid;
BEGIN
  SELECT * FROM roles_public.roles WHERE id=NEW.role_id INTO grantee_role;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'ROLES_ROLE_DOES_NOT_EXIST';
  END IF;

  SELECT * FROM roles_public.roles WHERE id=NEW.group_id INTO group_role;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'ROLES_ROLE_DOES_NOT_EXIST';
  END IF;

  IF (grantee_role.type = 'Team'::roles_public.role_type) THEN
    IF (group_role.type = 'Team'::roles_public.role_type) THEN
      RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_TEAM';
    END IF;
  END IF;

  IF (grantee_role.type = 'Organization'::roles_public.role_type) THEN
    IF (group_role.type = 'Team'::roles_public.role_type) THEN
      RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_ORG_TEAM';
    END IF;
  END IF;
  IF (grantee_role.type = 'Team'::roles_public.role_type) THEN
    IF (group_role.type = 'Organization'::roles_public.role_type) THEN
      RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_TEAM';
    END IF;
  END IF;

  IF (group_role.type = 'User'::roles_public.role_type) THEN
    RAISE EXCEPTION 'MEMBERSHIPS_CANNOT_GRANT_USER';
  END IF;

  -- sanitize organization_id
  IF (group_role.type = 'User'::roles_public.role_type) THEN
    v_organization_id = group_role.id;
  ELSIF (group_role.type = 'Team'::roles_public.role_type) THEN
    v_organization_id = group_role.organization_id;
  ELSIF (group_role.type = 'Organization'::roles_public.role_type) THEN
    v_organization_id = group_role.id;
  END IF;

  NEW.organization_id = v_organization_id;

  -- TODO avoid circular grants
  -- NOTE in order to avoid circular grants for now
  IF (grantee_role.type != 'User'::roles_public.role_type) THEN
    RAISE EXCEPTION 'MEMBERSHIPS_ONLY_USERS';
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;
-- NOTE using SECURITY DEFINER because otherwise we cannot check the user we are granting access!

COMMIT;
