-- Revert: schemas/launchql_public/tables/user_connections/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_public".user_connections
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

