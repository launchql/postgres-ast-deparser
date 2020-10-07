-- Verify schemas/ast_constants/procedures/constants  on pg

BEGIN;

SELECT verify_function ('ast_constants.constants');

ROLLBACK;
