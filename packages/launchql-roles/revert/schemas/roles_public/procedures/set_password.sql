-- Revert schemas/roles_public/procedures/set_password from pg

BEGIN;

DROP FUNCTION roles_public.set_password;

COMMIT;
