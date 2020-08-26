-- Revert schemas/roles_public/procedures/current_role from pg

BEGIN;

DROP FUNCTION roles_public.current_role;

COMMIT;
