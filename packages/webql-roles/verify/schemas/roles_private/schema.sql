-- Verify schemas/roles_private/schema on pg

BEGIN;

SELECT
    verify_schema ('roles_private');

ROLLBACK;
