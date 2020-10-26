-- Revert: schemas/launchql_public/tables/user_characteristics/triggers/tg_peoplestamps from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN created_by;
ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN updated_by;

DROP TRIGGER tg_peoplestamps
ON "launchql_rls_public".user_characteristics;


COMMIT;  

