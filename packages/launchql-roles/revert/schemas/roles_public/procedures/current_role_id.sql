-- Revert schemas/roles_public/procedures/current_role_id from pg

BEGIN;

DROP FUNCTION roles_public.current_role_id;

COMMIT;
