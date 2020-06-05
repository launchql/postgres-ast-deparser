-- Verify schemas/auth_private/grants/procedures/authenticate/grant_execute_to_anonymous on pg

BEGIN;

SELECT verify_function ('auth_private.authenticate', 'anonymous');

ROLLBACK;
