-- Revert: schemas/launchql_public/grants/usage/authenticated from pg

BEGIN;


REVOKE USAGE
ON SCHEMA "launchql_rls_public"
FROM authenticated;

COMMIT;  

