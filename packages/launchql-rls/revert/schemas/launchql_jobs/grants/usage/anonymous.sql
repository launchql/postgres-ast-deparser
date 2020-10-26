-- Revert: schemas/launchql_jobs/grants/usage/anonymous from pg

BEGIN;


REVOKE USAGE
ON SCHEMA "launchql_rls_jobs"
FROM anonymous;

COMMIT;  

