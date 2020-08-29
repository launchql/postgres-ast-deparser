-- Verify schemas/auth_private/procedures/multi_factor_auth  on pg

BEGIN;

SELECT verify_function ('auth_private.multi_factor_auth', current_user);

ROLLBACK;
