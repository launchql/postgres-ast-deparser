-- Verify schemas/auth_private/tables/token/table on pg

BEGIN;

SELECT
    verify_table ('auth_private.token');

ROLLBACK;
