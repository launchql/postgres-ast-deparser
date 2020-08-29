-- Revert schemas/content_private/schema from pg

BEGIN;

DROP SCHEMA content_private;

COMMIT;
