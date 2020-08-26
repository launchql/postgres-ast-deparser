-- Verify schemas/auth_private/tables/user_authentication_secrets/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('auth_private.user_authentication_secrets');

ROLLBACK;
