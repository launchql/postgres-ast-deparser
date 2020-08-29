-- Revert schemas/roles_private/procedures/registration/service_sign_in from pg

BEGIN;

DROP FUNCTION roles_private.service_sign_in;

COMMIT;
