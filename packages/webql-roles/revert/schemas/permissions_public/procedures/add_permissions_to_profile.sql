-- Revert schemas/permissions_public/procedures/add_permissions_to_profile from pg

BEGIN;

DROP FUNCTION permissions_public.add_permissions_to_profile;

COMMIT;
