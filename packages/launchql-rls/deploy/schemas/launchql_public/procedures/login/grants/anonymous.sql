-- Deploy: schemas/launchql_public/procedures/login/grants/anonymous to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/procedures/login/procedure
-- requires: schemas/launchql_public/procedures/register/procedure

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_public".login
TO anonymous;
COMMIT;
