-- Verify schemas/auth_private/procedures/current_token  on pg

BEGIN;

SELECT verify_function ('auth_private.current_token', current_user);

ROLLBACK;
