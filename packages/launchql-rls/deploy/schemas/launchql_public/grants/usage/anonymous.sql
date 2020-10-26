-- Deploy: schemas/launchql_public/grants/usage/anonymous to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_public/grants/usage/authenticated

BEGIN;

GRANT USAGE
ON SCHEMA "launchql_public"
TO anonymous;
COMMIT;
