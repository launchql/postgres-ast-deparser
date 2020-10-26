-- Deploy: schemas/launchql_jobs/grants/usage/authenticated to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_jobs/schema

BEGIN;

GRANT USAGE
ON SCHEMA "launchql_jobs"
TO authenticated;
COMMIT;
