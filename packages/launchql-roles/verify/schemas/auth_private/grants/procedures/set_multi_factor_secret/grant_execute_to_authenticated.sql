-- Verify schemas/auth_private/grants/procedures/set_multi_factor_secret/grant_execute_to_authenticated on pg

BEGIN;

SELECT verify_function ('auth_private.set_multi_factor_secret', 'authenticated');

ROLLBACK;
