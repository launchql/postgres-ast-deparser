-- Revert schemas/ast/schema from pg

BEGIN;

DROP SCHEMA ast;

COMMIT;
