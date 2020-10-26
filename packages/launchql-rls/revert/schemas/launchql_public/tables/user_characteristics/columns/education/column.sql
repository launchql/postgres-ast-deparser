-- Revert: schemas/launchql_public/tables/user_characteristics/columns/education/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_characteristics DROP COLUMN education;
COMMIT;  

