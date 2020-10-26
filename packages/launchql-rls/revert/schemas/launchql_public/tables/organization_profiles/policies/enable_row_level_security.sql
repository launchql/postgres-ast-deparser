-- Revert: schemas/launchql_public/tables/organization_profiles/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_public".organization_profiles
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

