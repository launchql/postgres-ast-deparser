-- Revert schemas/permissions_private/schema from pg

BEGIN;

DROP SCHEMA permissions_private;

COMMIT;
