-- Revert: schemas/launchql_public/tables/user_settings/columns/id/alterations/alt0000000052 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

