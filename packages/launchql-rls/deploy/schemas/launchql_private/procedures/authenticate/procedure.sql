-- Deploy: schemas/launchql_private/procedures/authenticate/procedure to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/tables/api_tokens/table
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token/column
-- requires: schemas/launchql_private/tables/api_tokens/columns/access_token_expires_at/column

BEGIN;

CREATE FUNCTION "launchql_private".authenticate (token_str text)
    RETURNS SETOF "launchql_private".api_tokens
AS $$
SELECT
    tkn.*
FROM
    "launchql_private".api_tokens AS tkn
WHERE
    tkn.access_token = authenticate.token_str
    AND EXTRACT(EPOCH FROM (tkn.access_token_expires_at-NOW())) > 0;
$$
LANGUAGE 'sql' STABLE
SECURITY DEFINER;
COMMIT;
