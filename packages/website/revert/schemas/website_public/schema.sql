-- Revert schemas/website_public/schema from pg

BEGIN;

DROP SCHEMA website_public;

COMMIT;
