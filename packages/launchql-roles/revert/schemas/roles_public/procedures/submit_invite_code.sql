-- Revert schemas/roles_public/procedures/submit_invite_code from pg

BEGIN;

DROP FUNCTION roles_public.submit_invite_code;

COMMIT;
