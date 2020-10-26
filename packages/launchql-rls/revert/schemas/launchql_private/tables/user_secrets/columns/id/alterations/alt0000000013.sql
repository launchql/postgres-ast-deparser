-- Revert: schemas/launchql_private/tables/user_secrets/columns/id/alterations/alt0000000013 from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

