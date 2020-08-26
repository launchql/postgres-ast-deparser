-- Revert schemas/files_public/schema from pg

BEGIN;

DROP SCHEMA files_public;

COMMIT;
