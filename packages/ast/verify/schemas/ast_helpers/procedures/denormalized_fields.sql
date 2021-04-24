-- Verify schemas/ast_helpers/procedures/denormalized_fields  on pg

BEGIN;

SELECT verify_function ('ast_helpers.denormalized_fields');

ROLLBACK;
