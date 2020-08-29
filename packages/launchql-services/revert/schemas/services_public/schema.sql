-- Revert schemas/services_public/schema from pg

BEGIN;

DROP SCHEMA services_public;

COMMIT;
