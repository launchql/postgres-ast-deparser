-- Revert: schemas/launchql_public/tables/organization_profiles/policies/authenticated_can_insert_on_organization_profiles from pg

BEGIN;
DROP POLICY authenticated_can_insert_on_organization_profiles ON "launchql_rls_public".organization_profiles;
COMMIT;  

