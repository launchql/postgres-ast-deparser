-- Deploy: schemas/launchql_public/grants/usage/authenticated to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema

BEGIN;

GRANT USAGE
ON SCHEMA "launchql_public"
TO authenticated;
COMMIT;
