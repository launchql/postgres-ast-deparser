-- Verify schemas/ast/procedures/utils  on pg

BEGIN;

SELECT verify_function ('ast.utils');

ROLLBACK;
