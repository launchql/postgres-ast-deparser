-- Revert schemas/website_private/schema from pg

BEGIN;

DROP SCHEMA website_private;

COMMIT;
