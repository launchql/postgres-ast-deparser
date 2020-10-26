-- Revert: schemas/launchql_public/tables/user_characteristics/columns/gender/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN gender;
COMMIT;  

