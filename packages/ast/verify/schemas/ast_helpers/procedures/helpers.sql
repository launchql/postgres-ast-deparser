-- Verify schemas/ast_helpers/procedures/helpers  on pg

BEGIN;

SELECT verify_function ('ast_helpers.helpers');

ROLLBACK;
