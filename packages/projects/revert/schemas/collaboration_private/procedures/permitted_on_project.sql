-- Revert schemas/collaboration_private/procedures/permitted_on_project from pg

BEGIN;

DROP FUNCTION collaboration_private.permitted_on_project;

COMMIT;
