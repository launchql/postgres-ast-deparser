-- Verify schemas/projects_public/schema on pg

BEGIN;

SELECT
    verify_schema ('projects_public');

ROLLBACK;
