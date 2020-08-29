-- Verify schemas/collaboration_private/views/user_project_permits/view on pg

BEGIN;

SELECT verify_table ('collaboration_private.user_project_permits');

ROLLBACK;
