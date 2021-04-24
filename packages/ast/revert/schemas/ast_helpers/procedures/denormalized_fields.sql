-- Revert schemas/ast_helpers/procedures/denormalized_fields from pg

BEGIN;

DROP FUNCTION ast_helpers.denormalized_fields;

COMMIT;
