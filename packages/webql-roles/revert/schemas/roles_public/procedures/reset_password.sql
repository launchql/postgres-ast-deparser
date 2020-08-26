-- Revert schemas/roles_public/procedures/reset_password from pg

BEGIN;

DROP FUNCTION roles_public.reset_password;

COMMIT;
