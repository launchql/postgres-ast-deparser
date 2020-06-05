-- Verify schemas/auth_private/tables/user_authentication_secrets/table on pg

BEGIN;

SELECT verify_table ('auth_private.user_authentication_secrets');

ROLLBACK;
