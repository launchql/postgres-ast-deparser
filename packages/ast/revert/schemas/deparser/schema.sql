-- Revert schemas/deparser/schema from pg

BEGIN;

DROP SCHEMA deparser;

COMMIT;
