-- Revert schemas/deparser/procedures/deparse from pg

BEGIN;

DROP FUNCTION deparser.deparse;

COMMIT;
