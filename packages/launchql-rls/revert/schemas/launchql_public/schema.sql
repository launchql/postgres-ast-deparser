-- Revert: schemas/launchql_public/schema from pg

BEGIN;


DROP SCHEMA IF EXISTS "launchql_rls_public" CASCADE;
COMMIT;  

