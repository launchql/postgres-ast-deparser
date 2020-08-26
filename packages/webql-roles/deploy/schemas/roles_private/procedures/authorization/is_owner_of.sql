-- Deploy schemas/roles_private/procedures/authorization/is_owner_of to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;

CREATE FUNCTION roles_private.is_owner_of(role_id UUID, group_id UUID)
    RETURNS BOOLEAN
AS $$
BEGIN
    IF role_id = group_id THEN
        RETURN TRUE;
    ELSIF EXISTS (
            SELECT
                1
            FROM
                roles_public.memberships m
                JOIN permissions_public.profile p
                ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
            WHERE
            		p.name = 'Owner'
		        AND m.role_id = is_owner_of.role_id
                AND m.group_id = is_owner_of.group_id
            ) THEN
            RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE
SECURITY DEFINER;

COMMIT;