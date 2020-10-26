-- Revert: schemas/launchql_public/tables/organization_profiles/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".organization_profiles FROM authenticated;
COMMIT;  

