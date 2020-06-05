-- Verify schemas/roles_private/procedures/registration/service_sign_in  on pg

BEGIN;

SELECT verify_function ('roles_private.service_sign_in', current_user);

ROLLBACK;
