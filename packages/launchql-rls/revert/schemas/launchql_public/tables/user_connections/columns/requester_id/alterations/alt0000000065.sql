-- Revert: schemas/launchql_public/tables/user_connections/columns/requester_id/alterations/alt0000000065 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections 
    ALTER COLUMN requester_id DROP NOT NULL;


COMMIT;  

