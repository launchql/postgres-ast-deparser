-- Verify schemas/projects_private/schema on pg

BEGIN;

SELECT
    verify_schema ('projects_private');

ROLLBACK;
