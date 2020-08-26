-- Deploy schemas/auth_private/procedures/current_token to pg
-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/token/table
BEGIN;

CREATE FUNCTION auth_private.current_token ()
  RETURNS auth_private.token
AS $$
DECLARE
  token auth_private.token;
BEGIN
  IF current_setting('jwt.claims.access_token', TRUE)
    IS NOT NULL THEN
    SELECT
      tkn.*
    FROM
      auth_private.token AS tkn
    WHERE
      tkn.access_token = current_setting('jwt.claims.access_token', TRUE)
      AND EXTRACT(EPOCH FROM (tkn.access_token_expires_at - NOW())) > 0 INTO token;
    RETURN token;
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE;

COMMIT;

