-- Revert: schemas/launchql_jobs/schema from pg

BEGIN;


DROP SCHEMA IF EXISTS "launchql_rls_jobs" CASCADE;
COMMIT;  

