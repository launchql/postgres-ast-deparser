-- Revert schemas/roles_public/procedures/register_organization from pg

BEGIN;

DROP FUNCTION roles_public.create_organization;

COMMIT;
