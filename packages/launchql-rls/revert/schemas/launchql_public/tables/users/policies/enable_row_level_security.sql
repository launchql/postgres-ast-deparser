-- Revert: schemas/launchql_public/tables/users/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_public".users
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

