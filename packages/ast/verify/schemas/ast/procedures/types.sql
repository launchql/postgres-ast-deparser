-- Verify schemas/ast/procedures/types  on pg

BEGIN;

SELECT verify_function ('ast.types');

ROLLBACK;
