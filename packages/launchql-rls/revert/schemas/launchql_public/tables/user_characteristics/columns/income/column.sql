-- Revert: schemas/launchql_public/tables/user_characteristics/columns/income/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN income;
COMMIT;  

