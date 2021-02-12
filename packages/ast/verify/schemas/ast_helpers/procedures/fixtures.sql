-- Verify schemas/ast_helpers/procedures/fixtures  on pg

BEGIN;

SELECT verify_function ('ast_helpers.fixtures');

ROLLBACK;
