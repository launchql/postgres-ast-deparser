-- Deploy: schemas/launchql_public/procedures/get_current_role_ids/grants/authenticated to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/procedures/get_current_role_ids/procedure

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_public".get_current_role_ids
TO authenticated;
COMMIT;
