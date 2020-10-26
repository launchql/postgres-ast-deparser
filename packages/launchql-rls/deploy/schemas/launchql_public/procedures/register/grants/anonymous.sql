-- Deploy: schemas/launchql_public/procedures/register/grants/anonymous to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/procedures/register/procedure
-- requires: schemas/launchql_public/procedures/login/grants/anonymous

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_public".register
TO anonymous;
COMMIT;
