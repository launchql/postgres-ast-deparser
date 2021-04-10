-- Verify schemas/ast_helpers/procedures/fields  on pg

BEGIN;

SELECT verify_function ('ast_helpers.fields');

ROLLBACK;
