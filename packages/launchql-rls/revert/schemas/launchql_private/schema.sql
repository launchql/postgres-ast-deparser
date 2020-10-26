-- Revert: schemas/launchql_private/schema from pg

BEGIN;


DROP SCHEMA IF EXISTS "launchql_rls_private" CASCADE;
COMMIT;  

