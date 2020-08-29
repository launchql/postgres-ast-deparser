-- Revert schemas/projects_public/schema from pg

BEGIN;

DROP SCHEMA projects_public;

COMMIT;
