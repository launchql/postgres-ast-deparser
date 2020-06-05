-- Verify schemas/collaboration_private/views/admin_project_permits/view on pg

BEGIN;

SELECT verify_table ('collaboration_private.admin_project_permits');

ROLLBACK;
