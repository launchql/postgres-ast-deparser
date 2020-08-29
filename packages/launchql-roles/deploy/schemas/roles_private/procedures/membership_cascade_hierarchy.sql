-- Deploy schemas/roles_private/procedures/membership_cascade_hierarchy to pg

-- requires: schemas/roles_private/schema

BEGIN;

CREATE FUNCTION roles_private.membership_cascade_hierarchy (
  membership roles_public.memberships
)
  RETURNS void
  AS $$
DECLARE
  membership_role roles_public.roles;
  membership_profile permissions_public.profile;
  obj record;
BEGIN

  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = membership.group_id INTO membership_role;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  SELECT
    *
  FROM
    permissions_public.profile
  WHERE
    id = membership.profile_id 
    AND organization_id = membership.organization_id
  INTO membership_profile;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  IF (
    membership_role.type = 'Organization'::roles_public.role_type 
    AND (
           membership_profile.name = 'Owner'
        OR membership_profile.name = 'Administrator'
      )
    ) THEN
    
    -- if it is organization
    -- cascade admins only

      FOR obj IN 
      with recursive cte as (
        select r2.* from roles_public.roles r2
          WHERE r2.id=membership.group_id
        union
        select r.*
        from roles_public.roles r, cte curr
        WHERE
          r.parent_id = curr.id AND
          r.organization_id = curr.organization_id
      )
      select * from cte
      LOOP
        INSERT INTO roles_public.memberships
        (role_id, group_id, profile_id, organization_id, inherited, membership_id)
        VALUES
        (membership.role_id, obj.id, membership.profile_id, obj.organization_id, true, membership.id)
        ON CONFLICT (role_id, group_id) DO NOTHING;

      END LOOP;


  ELSIF (membership_role.type = 'Team'::roles_public.role_type) THEN
    -- if it is a team
    -- cascade all
      FOR obj IN 
      with recursive cte as (
        select r2.* from roles_public.roles r2
          WHERE r2.id=membership.group_id
        union
        select r.*
        from roles_public.roles r, cte curr
        WHERE
          r.parent_id = curr.id AND
          r.organization_id = curr.organization_id
      )
      select * from cte
      LOOP
        INSERT INTO roles_public.memberships
        (role_id, group_id, profile_id, organization_id, inherited, membership_id)
        VALUES
        (membership.role_id, obj.id, membership.profile_id, obj.organization_id, true, membership.id)
        ON CONFLICT (role_id, group_id) DO NOTHING;

      END LOOP;


  END IF;

END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;
COMMIT;
