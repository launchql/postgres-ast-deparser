-- Deploy schemas/auth_public/procedures/create_service_token to pg
-- requires: schemas/auth_public/schema
-- requires: schemas/roles_public/schema
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type

BEGIN;

CREATE FUNCTION auth_public.create_service_token ()
  RETURNS auth_private.token
  AS $$
DECLARE
  v_token auth_private.token;
BEGIN
  INSERT INTO auth_private.token (TYPE, role_id)
    VALUES ('service'::auth_private.token_type, roles_public.current_role_id ())
  RETURNING
    * INTO v_token;
  RETURN v_token;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION auth_public.create_service_token TO authenticated;

COMMIT;

