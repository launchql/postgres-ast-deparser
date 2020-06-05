-- Deploy schemas/roles_private/procedures/validate_role_parent to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/procedures/get_all_parent_roles

BEGIN;

CREATE FUNCTION roles_private.validate_role_parent(
  role_to_validate roles_public.roles
)
RETURNS void as $$
DECLARE
  parent_roles uuid[];
  parent_role roles_public.roles;
BEGIN

    IF (role_to_validate.type != 'Team'::roles_public.role_type) THEN
      RAISE EXCEPTION 'ROLES_ONLY_TEAMS_HAVE_PARENTS';
    END IF;
    SELECT * FROM roles_private.get_all_parent_roles(role_to_validate.parent_id) INTO parent_roles;
    IF (role_to_validate.id = ANY(parent_roles)) THEN
      RAISE EXCEPTION 'ROLES_TEAM_CIRCULAR_REF';
    END IF;

    -- NOTE this requires SECURITY DEFINER
    SELECT * FROM roles_public.roles WHERE id=role_to_validate.parent_id INTO parent_role;

    IF (parent_role.type != 'Team'::roles_public.role_type) THEN
      IF (parent_role.type != 'Organization'::roles_public.role_type) THEN
        RAISE EXCEPTION 'ROLES_TEAM_PARENT_TYPE_MISMATCH';
      END IF;
    END IF;

    IF (role_to_validate.organization_id != parent_role.organization_id) THEN
      RAISE EXCEPTION 'ORGANIZATION_MISMASTCH';
    END IF;

END;
$$
LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;

COMMIT;
