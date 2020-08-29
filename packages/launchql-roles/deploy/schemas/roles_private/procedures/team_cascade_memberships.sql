-- Deploy schemas/roles_private/procedures/team_cascade_memberships to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type

BEGIN;

-- TODO indexes
-- TODO check, organization vs team, should orgs to this too?

CREATE FUNCTION roles_private.get_team_parent_roles (role_id uuid)
RETURNS setof roles_public.roles AS $$
WITH RECURSIVE cte AS (
    SELECT
        r2.* from roles_public.roles r2 WHERE r2.id=get_team_parent_roles.role_id
    UNION
    SELECT
        r.*
    FROM
        roles_public.roles r,
        cte curr
    WHERE
        curr.parent_id = r.id
        AND r.organization_id = curr.organization_id
) SELECT * FROM cte;
$$
LANGUAGE 'sql' STABLE;

CREATE FUNCTION roles_private.team_cascade_memberships(
      team_id uuid,
      organization_id uuid
 ) returns void as $$
DECLARE
  parent record;
  membership record;
BEGIN

    FOR parent in
    SELECT *
    FROM roles_private.get_team_parent_roles(team_cascade_memberships.team_id)
    LOOP

      FOR membership in SELECT *
      FROM roles_public.memberships m
      WHERE (m.group_id = parent.id AND m.organization_id = parent.organization_id)
      LOOP
        INSERT INTO roles_public.memberships
        (role_id, group_id, profile_id, organization_id, inherited, membership_id)
        VALUES
        (membership.role_id, team_cascade_memberships.team_id, membership.profile_id, team_cascade_memberships.organization_id, true, membership.id)
        ON CONFLICT (role_id, group_id) DO NOTHING;

      END LOOP;
    END LOOP;

END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;


COMMIT;
