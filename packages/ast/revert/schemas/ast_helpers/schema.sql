-- Revert schemas/ast_helpers/schema from pg

BEGIN;

DROP SCHEMA ast_helpers;

COMMIT;
