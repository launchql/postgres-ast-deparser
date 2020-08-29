-- Deploy schemas/collaboration_private/views/user_project_permits/view to pg

-- requires: schemas/collaboration_private/schema
-- requires: schemas/collaboration_public/tables/collaboration/table
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE VIEW collaboration_private.user_project_permits AS
SELECT

      perm.id as permission_id,
      perm.action_type as action_type,
      perm.object_type as object_type,
      -- c.organization_id as organization_id,
      c.project_id as project_id,
      c.role_id as actor_id
      
      FROM
      collaboration_public.collaboration c
      JOIN permissions_private.profile_permissions jtbl
      	ON (jtbl.profile_id = c.profile_id AND jtbl.organization_id = c.organization_id)
      JOIN permissions_public.permission perm
        ON jtbl.permission_id = perm.id
      JOIN roles_public.roles r
        ON c.role_id = r.id
      WHERE
        r.type = 'User'::roles_public.role_type
      ;
COMMIT;
