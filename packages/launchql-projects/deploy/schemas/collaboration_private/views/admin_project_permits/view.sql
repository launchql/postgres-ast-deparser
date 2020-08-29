-- Deploy schemas/collaboration_private/views/admin_project_permits/view to pg

-- requires: schemas/collaboration_private/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE VIEW collaboration_private.admin_project_permits AS
SELECT

      perm.id as permission_id,
      perm.action_type as action_type,
      perm.object_type as object_type,
      -- c.organization_id as organization_id,
      project.id as project_id,
      membership.role_id as actor_id
      
      FROM
      roles_public.memberships membership
      JOIN projects_public.project project
        ON project.owner_id = membership.organization_id
      JOIN permissions_private.profile_permissions jtbl
      	ON (jtbl.profile_id = membership.profile_id AND jtbl.organization_id = membership.organization_id)
      JOIN permissions_public.profile prof
        ON (prof.id = jtbl.profile_id AND prof.organization_id = jtbl.organization_id)
      JOIN permissions_public.permission perm
        ON jtbl.permission_id = perm.id
      JOIN roles_public.roles r
        ON membership.role_id = r.id
      WHERE
        r.type = 'User'::roles_public.role_type
        AND membership.organization_id = membership.group_id
        AND (prof.name = 'Administrator' OR prof.name = 'Owner')
      ;


COMMIT;
