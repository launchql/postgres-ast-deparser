-- Deploy schemas/roles_private/procedures/get_all_parent_roles to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

-- NOTE private and security definer so
-- it does not need to use RLS
CREATE FUNCTION roles_private.get_all_parent_roles (
  check_role_id uuid DEFAULT roles_public.current_role_id()
)
    RETURNS uuid[]
AS $$
DECLARE
   results uuid[];
   base_role roles_public.roles;
BEGIN

IF check_role_id IS NULL THEN
  RETURN ARRAY[];
END IF;

SELECT * FROM roles_public.roles WHERE id=check_role_id INTO base_role;

WITH RECURSIVE cte (role_id, parent_id, organization_id) AS (
    SELECT
        base_role.id, base_role.parent_id, base_role.organization_id
    UNION
    SELECT
        r.id, r.parent_id, r.organization_id
    FROM
        roles_public.roles r,
        cte curr
    WHERE
        curr.parent_id = r.id
        AND r.organization_id = curr.organization_id
)
SELECT
    array_agg(distinct(role_id))
FROM
    cte
INTO results;

RETURN results;

END;
$$
LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;

COMMIT;
