-- Revert: schemas/launchql_private/tables/user_secrets/columns/name/alterations/alt0000000015 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets 
    ALTER COLUMN name DROP NOT NULL;


COMMIT;  

