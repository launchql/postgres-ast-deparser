-- Revert schemas/roles_public/procedures/verify_email from pg

BEGIN;

DROP FUNCTION roles_public.verify_email;

COMMIT;
