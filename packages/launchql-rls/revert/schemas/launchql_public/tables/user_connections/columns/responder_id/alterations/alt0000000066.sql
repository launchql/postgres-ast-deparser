-- Revert: schemas/launchql_public/tables/user_connections/columns/responder_id/alterations/alt0000000066 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections 
    ALTER COLUMN responder_id DROP NOT NULL;


COMMIT;  

