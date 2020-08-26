-- Revert schemas/permissions_public/schema from pg

BEGIN;

DROP SCHEMA permissions_public;

COMMIT;
