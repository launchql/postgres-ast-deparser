-- Revert: schemas/launchql_public/grants/usage/anonymous from pg

BEGIN;


REVOKE USAGE
ON SCHEMA "launchql_rls_public"
FROM anonymous;

COMMIT;  

