-- Revert schemas/roles_public/schema from pg

BEGIN;

DROP SCHEMA roles_public;

COMMIT;
