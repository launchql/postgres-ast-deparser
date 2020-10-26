-- Revert: schemas/launchql_public/tables/user_characteristics/triggers/tg_timestamps from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN created_at;
ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN updated_at;

DROP TRIGGER tg_timestamps ON "launchql_rls_public".user_characteristics;

COMMIT;  

