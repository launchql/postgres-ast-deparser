-- Verify schemas/ast_helpers/procedures/permissions  on pg

BEGIN;

SELECT verify_function ('ast_helpers.permissions');

ROLLBACK;
