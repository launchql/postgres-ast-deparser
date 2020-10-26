-- Verify: schemas/launchql_public/tables/organization_profiles/policies/authenticated_can_update_on_organization_profiles on pg

BEGIN;
SELECT verify_policy('authenticated_can_update_on_organization_profiles', 'launchql_rls_public.organization_profiles');
COMMIT;  

