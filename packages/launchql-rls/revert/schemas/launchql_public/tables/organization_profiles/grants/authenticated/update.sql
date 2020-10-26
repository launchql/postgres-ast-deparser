-- Revert: schemas/launchql_public/tables/organization_profiles/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".organization_profiles FROM authenticated;
COMMIT;  

