-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/columns/name/alterations/alt0000000030 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets 
    ALTER COLUMN name DROP NOT NULL;


COMMIT;  

