-- Revert schemas/collaboration_private/views/user_project_permits/view from pg

BEGIN;

DROP VIEW collaboration_private.user_project_permits;

COMMIT;
