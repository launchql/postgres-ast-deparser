-- Deploy: schemas/launchql_jobs/grants/usage/anonymous to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_jobs/schema
-- requires: schemas/launchql_jobs/grants/usage/authenticated

BEGIN;

GRANT USAGE
ON SCHEMA "launchql_jobs"
TO anonymous;
COMMIT;
