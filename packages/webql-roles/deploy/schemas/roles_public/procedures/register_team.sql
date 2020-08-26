-- Deploy schemas/roles_public/procedures/register_team to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/procedures/current_role_id
-- requires: schemas/roles_private/procedures/registration/register_role

BEGIN;

CREATE FUNCTION roles_public.register_team(
  display_name text,
  organization_id uuid,
  parent_id uuid DEFAULT NULL
) RETURNS roles_public.roles as $$
DECLARE
  team roles_public.roles;
BEGIN
  SELECT * FROM roles_private.register_role
    ('Team', NULL, display_name, NULL, organization_id, parent_id) INTO team;
  RETURN team;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

GRANT EXECUTE ON FUNCTION roles_public.register_team to authenticated;

COMMIT;
