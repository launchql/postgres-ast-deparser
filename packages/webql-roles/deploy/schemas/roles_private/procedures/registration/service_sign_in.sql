-- Deploy schemas/roles_private/procedures/registration/service_sign_in to pg
-- requires: schemas/roles_private/schema
-- requires: schemas/auth_private/tables/token/table
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/auth_public/tables/user_authentications/table
BEGIN;

CREATE FUNCTION roles_private.service_sign_in (user_id uuid, service text -- TODO handle identifier and remove user_id (role_id)
)
  RETURNS auth_private.token
AS $$
DECLARE
  authentications auth_public.user_authentications;
  token auth_private.token;
BEGIN
  SELECT
    ct.* INTO authentications
  FROM
    auth_public.user_authentications AS ct
  WHERE
    ct.role_id = service_sign_in.user_id
    AND ct.service = service_sign_in.service;
  IF (NOT FOUND) THEN
    RETURN NULL;
  END IF;
  INSERT INTO auth_private.token (TYPE, role_id, auth_id)
  VALUES ('auth'::auth_private.token_type, service_sign_in.user_id, authentications.id)
RETURNING
  * INTO token;
  RETURN token;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION roles_private.service_sign_in TO anonymous;

-- only revoke because of default privs grant on this schema
REVOKE EXECUTE ON FUNCTION roles_private.service_sign_in
FROM
  authenticated;

COMMENT ON FUNCTION roles_private.service_sign_in IS 'Grants a token without any auth. The auth is done by a 3rd party. This should never, ever touch the client API.';

COMMIT;

