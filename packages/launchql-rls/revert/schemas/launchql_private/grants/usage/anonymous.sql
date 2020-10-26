-- Revert: schemas/launchql_private/grants/usage/anonymous from pg

BEGIN;


REVOKE USAGE
ON SCHEMA "launchql_rls_private"
FROM anonymous;

COMMIT;  

