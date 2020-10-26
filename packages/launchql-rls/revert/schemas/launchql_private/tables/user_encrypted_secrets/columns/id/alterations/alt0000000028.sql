-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/columns/id/alterations/alt0000000028 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_encrypted_secrets 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

