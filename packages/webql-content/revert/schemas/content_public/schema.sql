-- Revert schemas/content_public/schema from pg

BEGIN;

DROP SCHEMA content_public;

COMMIT;
