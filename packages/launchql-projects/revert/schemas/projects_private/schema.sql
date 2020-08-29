-- Revert schemas/projects_private/schema from pg

BEGIN;

DROP SCHEMA projects_private;

COMMIT;
