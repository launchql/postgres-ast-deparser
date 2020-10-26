-- Deploy: schemas/launchql_private/grants/usage/anonymous to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/grants/usage/authenticated

BEGIN;

GRANT USAGE
ON SCHEMA "launchql_private"
TO anonymous;
COMMIT;
