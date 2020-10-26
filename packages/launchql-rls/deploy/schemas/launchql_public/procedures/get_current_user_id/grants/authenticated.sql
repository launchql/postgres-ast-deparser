-- Deploy: schemas/launchql_public/procedures/get_current_user_id/grants/authenticated to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/procedures/get_current_user_id/procedure

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_public".get_current_user_id
TO authenticated;
COMMIT;
