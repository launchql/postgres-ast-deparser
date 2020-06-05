-- Revert schemas/permissions_private/procedures/initialize_organization_profiles_and_permissions from pg

BEGIN;

DROP FUNCTION permissions_public.initialize_organization_profiles_and_permissions;

COMMIT;
