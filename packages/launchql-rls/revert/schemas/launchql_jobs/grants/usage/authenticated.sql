-- Revert: schemas/launchql_jobs/grants/usage/authenticated from pg

BEGIN;


REVOKE USAGE
ON SCHEMA "launchql_rls_jobs"
FROM authenticated;

COMMIT;  

