-- Deploy schemas/permissions_private/views/team_permits/view to pg

-- requires: schemas/permissions_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/tables/role_profiles/table
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/permissions_private/tables/profile_permissions/table

BEGIN;

CREATE VIEW permissions_private.team_permits AS
SELECT

      perm.id as permission_id,
      perm.action_type as action_type,
      perm.object_type as object_type,

      membership.group_id as role_id, -- the team or org! (change to resource_id)
      membership.role_id as actor_id, -- the person who can do it

      rp.display_name as group,
      r.username,
      perm.name as name
      
      
      FROM
      roles_public.memberships membership
      JOIN permissions_private.profile_permissions jtbl
      	ON (jtbl.profile_id = membership.profile_id AND jtbl.organization_id = membership.organization_id)
      JOIN permissions_public.permission perm
        ON jtbl.permission_id = perm.id
      JOIN roles_public.roles r
        ON membership.role_id = r.id
      JOIN roles_public.roles r2
        ON membership.group_id = r2.id
      JOIN roles_public.role_profiles rp
        ON rp.role_id = r2.id
      WHERE
        r.type = 'User'::roles_public.role_type

      ;

COMMIT;
