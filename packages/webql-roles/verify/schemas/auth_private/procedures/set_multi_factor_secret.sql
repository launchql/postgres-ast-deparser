-- Verify schemas/auth_private/procedures/set_multi_factor_secret  on pg

BEGIN;

SELECT verify_function ('auth_private.set_multi_factor_secret', current_user);

ROLLBACK;
