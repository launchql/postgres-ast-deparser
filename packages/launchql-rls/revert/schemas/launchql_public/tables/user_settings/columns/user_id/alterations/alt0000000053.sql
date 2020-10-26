-- Revert: schemas/launchql_public/tables/user_settings/columns/user_id/alterations/alt0000000053 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_settings 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

