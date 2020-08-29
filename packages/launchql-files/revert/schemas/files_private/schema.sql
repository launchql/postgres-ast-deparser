-- Revert schemas/files_private/schema from pg

BEGIN;

DROP SCHEMA files_private;

COMMIT;
