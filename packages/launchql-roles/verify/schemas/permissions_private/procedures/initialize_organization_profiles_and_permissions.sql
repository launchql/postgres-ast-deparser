-- Verify schemas/permissions_private/procedures/initialize_organization_profiles_and_permissions  on pg

BEGIN;

SELECT verify_function ('permissions_public.initialize_organization_profiles_and_permissions');

ROLLBACK;
