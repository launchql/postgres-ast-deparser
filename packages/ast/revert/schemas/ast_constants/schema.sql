-- Revert schemas/ast_constants/schema from pg

BEGIN;

DROP SCHEMA ast_constants;

COMMIT;
