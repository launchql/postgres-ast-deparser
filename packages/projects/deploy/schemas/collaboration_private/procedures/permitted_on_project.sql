-- Deploy schemas/collaboration_private/procedures/permitted_on_project to pg
-- requires: schemas/collaboration_private/schema
-- requires: schemas/collaboration_private/views/project_permits/view

BEGIN;
CREATE FUNCTION collaboration_private.permitted_on_project (
  action_type citext,
  object_type citext,
  project_id uuid,
  actor_id uuid DEFAULT roles_public.current_role_id ()
)
  RETURNS boolean
  AS $$
  SELECT
    -- NOTE we could remove this by adding a membership to yourself
    actor_id = (SELECT owner_id
      FROM projects_public.project
      WHERE id=project_id)
    OR
    EXISTS (
      SELECT
        1
      FROM
        collaboration_private.project_permits p
      WHERE
        p.action_type = permitted_on_project.action_type
        AND p.object_type = permitted_on_project.object_type
        AND p.project_id = permitted_on_project.project_id
        AND p.actor_id = permitted_on_project.actor_id
    );
$$
LANGUAGE 'sql'
STABLE
SECURITY DEFINER;
COMMIT;

