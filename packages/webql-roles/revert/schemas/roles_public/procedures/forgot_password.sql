-- Revert schemas/roles_public/procedures/forgot_password from pg

BEGIN;

DROP FUNCTION roles_public.forgot_password;

COMMIT;
