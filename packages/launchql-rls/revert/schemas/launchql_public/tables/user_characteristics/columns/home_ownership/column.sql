-- Revert: schemas/launchql_public/tables/user_characteristics/columns/home_ownership/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN home_ownership;
COMMIT;  

