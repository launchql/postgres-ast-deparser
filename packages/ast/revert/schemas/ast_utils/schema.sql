-- Revert schemas/ast_utils/schema from pg

BEGIN;

DROP SCHEMA ast_utils;

COMMIT;
