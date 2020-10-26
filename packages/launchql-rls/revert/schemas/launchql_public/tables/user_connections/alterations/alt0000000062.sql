-- Revert: schemas/launchql_public/tables/user_connections/alterations/alt0000000062 from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections
    ENABLE ROW LEVEL SECURITY;

COMMIT;  

