-- Revert: schemas/launchql_public/tables/user_connections/constraints/user_connections_requester_id_fkey from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections 
    DROP CONSTRAINT user_connections_requester_id_fkey;

COMMIT;  

