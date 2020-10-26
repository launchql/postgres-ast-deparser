-- Revert: schemas/launchql_public/tables/user_connections/columns/id/alterations/alt0000000064 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections 
    ALTER COLUMN id DROP DEFAULT;

COMMIT;  

