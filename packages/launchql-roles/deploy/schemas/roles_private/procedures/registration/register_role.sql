-- Deploy schemas/roles_private/procedures/registration/register_role to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/user_emails/table
-- requires: schemas/roles_private/tables/user_secrets/table
-- requires: schemas/roles_public/types/role_type

BEGIN;
CREATE FUNCTION roles_private.register_role_profile (
  role_id uuid,
  display_name text,
  avatar_url text,
  organization_id uuid
)
  RETURNS void
  AS $$
BEGIN
  INSERT INTO roles_public.role_profiles (role_id, display_name, avatar_url, organization_id)
  VALUES (role_id, display_name, avatar_url, organization_id);
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;
-- NOTE SECURITY DEFINER here because role_profile needed a permission, which upon creation, and trigger order, we dont have

CREATE FUNCTION roles_private.register_role (
  TYPE roles_public.role_type,
  username text,
  display_name text,
  avatar_url text,
  organization_id uuid DEFAULT NULL,
  parent_id uuid DEFAULT NULL
)
  RETURNS roles_public.roles
  AS $$
DECLARE
  new_role roles_public.roles;
  new_organization_id uuid;
  v_username text;
BEGIN
  IF (TYPE = 'User'::roles_public.role_type OR TYPE = 'Organization'::roles_public.role_type) THEN
    SELECT
      *
    FROM
      roles_public.available_username (COALESCE(username, display_name)) INTO v_username;
  END IF;
  INSERT INTO roles_public.roles (TYPE, username, parent_id, organization_id)
  VALUES (TYPE, v_username, parent_id, organization_id)
RETURNING
  * INTO new_role;
  IF (organization_id IS NULL) THEN
    new_organization_id = new_role.id;
  ELSE
    new_organization_id = organization_id;
  END IF;
  PERFORM
    roles_private.register_role_profile (new_role.id,
      display_name,
      avatar_url,
      new_organization_id);
  RETURN new_role;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;
GRANT EXECUTE ON FUNCTION roles_private.register_role TO anonymous;
COMMIT;

