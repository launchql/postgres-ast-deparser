-- Revert schemas/roles_public/procedures/available_username from pg

BEGIN;

DROP FUNCTION roles_public.available_username;

COMMIT;
