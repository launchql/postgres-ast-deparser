-- Deploy schemas/roles_public/procedures/register_organization to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/roles_private/procedures/registration/register_role
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/permissions_private/procedures/initialize_organization_profiles_and_permissions

BEGIN;
CREATE FUNCTION roles_public.register_organization (
  display_name text
)
  RETURNS roles_public.roles
  AS $$
DECLARE
  v_organization roles_public.roles;
  v_admin_profile permissions_public.profile;
BEGIN
  
  SELECT
    *
  FROM
    roles_private.register_role ('Organization',
      NULL,
      display_name, 
      NULL) INTO v_organization;
  
  PERFORM permissions_private.initialize_organization_profiles_and_permissions (v_organization.id);

  SELECT
    *
  FROM
    permissions_public.profile pf
  WHERE
    name = 'Owner' INTO v_admin_profile
    AND pf.organization_id = v_organization.id;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'CANNOT_CREATE_ORG';
  END IF;

  INSERT INTO roles_public.memberships (profile_id, role_id, group_id, organization_id)
    VALUES (v_admin_profile.id, roles_public.current_role_id (), v_organization.id, v_organization.id);
  RETURN v_organization;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION roles_public.register_organization TO authenticated;
COMMIT;
