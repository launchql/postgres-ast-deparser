-- Revert schemas/collaboration_private/views/team_project_permits/view from pg

BEGIN;

DROP VIEW collaboration_private.team_project_permits;

COMMIT;
