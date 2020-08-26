-- Verify schemas/roles_public/schema on pg

BEGIN;

SELECT
    verify_schema ('roles_public');

ROLLBACK;
