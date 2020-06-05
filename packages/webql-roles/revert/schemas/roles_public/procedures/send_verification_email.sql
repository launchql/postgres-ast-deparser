-- Revert schemas/roles_public/procedures/send_verification_email from pg

BEGIN;

DROP FUNCTION roles_public.send_verification_email;

COMMIT;
