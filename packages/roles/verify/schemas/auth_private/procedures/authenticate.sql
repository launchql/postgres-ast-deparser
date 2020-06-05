-- Verify schemas/auth_private/procedures/authenticate  on pg

BEGIN;

SELECT
    verify_function ('auth_private.authenticate',
        current_user);

ROLLBACK;
