-- Revert schemas/roles_public/procedures/sign_in from pg

BEGIN;

DROP FUNCTION roles_public.sign_in;

COMMIT;
