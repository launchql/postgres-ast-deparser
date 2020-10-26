-- Revert: schemas/launchql_public/tables/organization_profiles/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".organization_profiles FROM authenticated;
COMMIT;  

