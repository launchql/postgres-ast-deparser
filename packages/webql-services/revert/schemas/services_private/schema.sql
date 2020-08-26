-- Revert schemas/services_private/schema from pg

BEGIN;

DROP SCHEMA services_private;

COMMIT;
