-- Revert: schemas/launchql_public/tables/goals/triggers/tg_timestamps from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals DROP COLUMN created_at;
ALTER TABLE "launchql_rls_public".goals DROP COLUMN updated_at;

DROP TRIGGER tg_timestamps ON "launchql_rls_public".goals;

COMMIT;  

