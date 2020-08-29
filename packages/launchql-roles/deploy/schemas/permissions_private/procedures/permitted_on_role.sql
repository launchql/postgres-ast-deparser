-- Deploy schemas/permissions_private/procedures/permitted_on_role to pg
-- requires: schemas/permissions_private/schema
-- requires: schemas/permissions_private/views/team_permits/view
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;
CREATE FUNCTION permissions_private.permitted_on_role (
  action_type citext,
  object_type citext,
  role_id uuid,
  actor_id uuid DEFAULT roles_public.current_role_id ()
)
  RETURNS boolean
  AS $$
  SELECT
    role_id = actor_id
    OR
    EXISTS (
      SELECT
        1
      FROM
        permissions_private.team_permits p
      WHERE
        p.action_type = permitted_on_role.action_type
        AND p.object_type = permitted_on_role.object_type
        AND p.role_id = permitted_on_role.role_id
        AND p.actor_id = permitted_on_role.actor_id);
$$
LANGUAGE 'sql'
STABLE
SECURITY DEFINER;
COMMIT;

