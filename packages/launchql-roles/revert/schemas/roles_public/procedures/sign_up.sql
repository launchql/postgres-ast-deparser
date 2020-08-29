-- Revert schemas/roles_public/procedures/sign_up from pg

BEGIN;

DROP FUNCTION roles_public.sign_up;

COMMIT;
