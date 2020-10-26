-- Revert: schemas/launchql_jobs/alterations/alt0000000002 from pg

BEGIN;

DROP SCHEMA "launchql_rls_jobs" CASCADE;


COMMIT;  

