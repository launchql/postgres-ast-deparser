-- Revert schemas/collaboration_private/views/admin_project_permits/view from pg

BEGIN;

DROP VIEW collaboration_private.admin_project_permits;

COMMIT;
