-- Verify schemas/ast_helpers/procedures/rls  on pg

BEGIN;

SELECT verify_function ('ast_helpers.rls');

ROLLBACK;
