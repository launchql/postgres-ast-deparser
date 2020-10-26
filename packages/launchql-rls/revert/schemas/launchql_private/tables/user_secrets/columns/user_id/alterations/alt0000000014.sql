-- Revert: schemas/launchql_private/tables/user_secrets/columns/user_id/alterations/alt0000000014 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets 
    ALTER COLUMN user_id DROP NOT NULL;


COMMIT;  

