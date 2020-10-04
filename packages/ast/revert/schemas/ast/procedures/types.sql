-- Revert schemas/ast/procedures/types from pg

BEGIN;

DROP FUNCTION ast.types;

COMMIT;
