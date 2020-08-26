-- Verify schemas/collaboration_private/procedures/permitted_on_project  on pg

BEGIN;

SELECT verify_function ('collaboration_private.permitted_on_project');

ROLLBACK;
