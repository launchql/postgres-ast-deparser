-- Revert schemas/roles_private/schema from pg

BEGIN;

DROP SCHEMA roles_private;

COMMIT;
