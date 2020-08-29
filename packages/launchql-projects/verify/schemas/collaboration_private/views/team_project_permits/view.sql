-- Verify schemas/collaboration_private/views/team_project_permits/view on pg

BEGIN;

SELECT verify_table ('collaboration_private.team_project_permits');

ROLLBACK;
