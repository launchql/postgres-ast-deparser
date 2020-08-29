-- Revert schemas/collaboration_private/views/project_permits/view from pg

BEGIN;

DROP VIEW collaboration_private.project_permits;

COMMIT;
