-- Deploy schemas/roles_public/procedures/current_role to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

CREATE FUNCTION roles_public.current_role()
    RETURNS roles_public.roles
AS $$
DECLARE
  v_user roles_public.roles;
BEGIN
  IF roles_public.current_role_id() IS NOT NULL THEN
     SELECT * FROM roles_public.roles WHERE id = roles_public.current_role_id() INTO v_user;
     RETURN v_user;
  ELSE
     RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE;

GRANT EXECUTE ON FUNCTION roles_public.current_role to anonymous, authenticated;

COMMIT;
