-- Revert: schemas/launchql_private/grants/usage/authenticated from pg

BEGIN;


REVOKE USAGE
ON SCHEMA "launchql_rls_private"
FROM authenticated;

COMMIT;  

