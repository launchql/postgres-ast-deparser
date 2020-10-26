-- Revert: schemas/launchql_public/tables/goals/triggers/tg_peoplestamps from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN created_by;
ALTER TABLE "launchql_rls_public".goals DROP COLUMN updated_by;

DROP TRIGGER tg_peoplestamps
ON "launchql_rls_public".goals;


COMMIT;  

