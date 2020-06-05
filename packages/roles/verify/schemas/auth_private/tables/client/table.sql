-- Verify schemas/auth_private/tables/client/table on pg

BEGIN;

SELECT
    verify_table ('auth_private.client');

ROLLBACK;
