-- Deploy schemas/roles_private/procedures/authorization/is_member_of to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;

CREATE FUNCTION roles_private.is_member_of (role_id UUID, group_id UUID)
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
            WHERE
                m.role_id = is_member_of.role_id
                AND m.group_id = is_member_of.group_id) THEN
            RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE
SECURITY DEFINER;

COMMIT;