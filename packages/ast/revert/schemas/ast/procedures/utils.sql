-- Revert schemas/ast/procedures/utils from pg

BEGIN;

DROP FUNCTION ast.utils;

COMMIT;
