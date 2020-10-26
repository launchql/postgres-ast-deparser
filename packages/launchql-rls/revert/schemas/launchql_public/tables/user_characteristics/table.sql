-- Revert: schemas/launchql_public/tables/user_characteristics/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".user_characteristics;
COMMIT;  

