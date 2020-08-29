-- Deploy schemas/auth_private/procedures/authenticate to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/auth_private/tables/token/table

BEGIN;

CREATE FUNCTION auth_private.authenticate (token text)
    RETURNS setof auth_private.token
AS $$
SELECT
    tkn.*
FROM
    auth_private.token AS tkn
WHERE
    tkn.access_token = authenticate.token
    AND EXTRACT(EPOCH FROM (tkn.access_token_expires_at-NOW())) > 0;
$$
LANGUAGE 'sql' STABLE
SECURITY DEFINER;

COMMIT;
