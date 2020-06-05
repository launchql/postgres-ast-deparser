-- Verify schemas/collaboration_private/views/project_permits/view on pg

BEGIN;

SELECT verify_table ('collaboration_private.project_permits');

ROLLBACK;
