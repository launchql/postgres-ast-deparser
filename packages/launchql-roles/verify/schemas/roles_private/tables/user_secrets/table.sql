-- Verify schemas/roles_private/tables/user_secrets/table on pg

BEGIN;

SELECT
verify_table ('roles_private.user_secrets');

ROLLBACK;
