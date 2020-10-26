-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/columns/user_id/alterations/alt0000000029 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

