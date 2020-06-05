-- Deploy schemas/roles_private/procedures/authorization/is_member_of_organization to pg
-- requires: schemas/roles_private/schema

BEGIN;
CREATE FUNCTION roles_private.is_member_of_organization (
  role_id UUID,
  organization_id UUID
)
  RETURNS BOOLEAN
  AS $$
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        roles_public.memberships m
      WHERE
        m.role_id = is_member_of_organization.role_id
        AND m.organization_id = is_member_of_organization.organization_id);
$$
LANGUAGE 'sql'
STABLE
SECURITY DEFINER;
COMMIT;

