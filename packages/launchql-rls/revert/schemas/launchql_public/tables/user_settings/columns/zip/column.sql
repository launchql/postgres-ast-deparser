-- Revert: schemas/launchql_public/tables/user_settings/columns/zip/column from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings DROP COLUMN zip;
COMMIT;  

