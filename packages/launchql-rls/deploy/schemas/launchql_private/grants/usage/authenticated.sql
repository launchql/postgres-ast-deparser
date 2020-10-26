-- Deploy: schemas/launchql_private/grants/usage/authenticated to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema

BEGIN;

GRANT USAGE
ON SCHEMA "launchql_private"
TO authenticated;
COMMIT;
