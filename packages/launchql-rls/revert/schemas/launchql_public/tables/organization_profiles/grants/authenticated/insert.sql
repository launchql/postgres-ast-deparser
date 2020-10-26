-- Revert: schemas/launchql_public/tables/organization_profiles/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".organization_profiles FROM authenticated;
COMMIT;  

