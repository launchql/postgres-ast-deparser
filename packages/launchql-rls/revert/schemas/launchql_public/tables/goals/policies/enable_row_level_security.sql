-- Revert: schemas/launchql_public/tables/goals/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_public".goals
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

