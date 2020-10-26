-- Revert: schemas/launchql_public/tables/user_connections/columns/id/alterations/alt0000000063 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections 
    ALTER COLUMN id DROP NOT NULL;


COMMIT;  

