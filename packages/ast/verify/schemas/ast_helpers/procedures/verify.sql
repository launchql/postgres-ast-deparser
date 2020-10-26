-- Verify schemas/ast_helpers/procedures/verify  on pg

BEGIN;

SELECT verify_function ('ast_helpers.verify');

ROLLBACK;
