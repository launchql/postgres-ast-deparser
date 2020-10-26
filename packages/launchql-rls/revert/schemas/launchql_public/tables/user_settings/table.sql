-- Revert: schemas/launchql_public/tables/user_settings/table from pg

BEGIN;
DROP TABLE "launchql_rls_public".user_settings;
COMMIT;  

