-- Deploy schemas/collaboration_private/views/team_project_permits/view to pg

-- requires: schemas/collaboration_private/schema
-- requires: schemas/collaboration_public/tables/collaboration/table
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE VIEW collaboration_private.team_project_permits AS
SELECT

      perm.id as permission_id,
      perm.action_type as action_type,
      perm.object_type as object_type,
      -- c.organization_id as organization_id,
      c.project_id as project_id,
      m.role_id as actor_id
      
      FROM
      permissions_private.profile_permissions jtbl
      JOIN permissions_public.permission perm
        ON jtbl.permission_id = perm.id
      JOIN collaboration_public.collaboration c 
      	ON (jtbl.profile_id = c.profile_id AND jtbl.organization_id = c.organization_id)
      JOIN roles_public.memberships m
      	-- ON (m.group_id = c.role_id OR m.role_id = c.role_id)
      	-- ON m.role_id = c.role_id
      	ON m.group_id = c.role_id
      JOIN roles_public.roles r
        ON c.role_id = r.id
      WHERE
        r.type = 'Team'::roles_public.role_type
      ;

COMMIT;
