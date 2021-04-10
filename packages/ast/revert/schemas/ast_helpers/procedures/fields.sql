-- Revert schemas/ast_helpers/procedures/fields from pg

BEGIN;

DROP FUNCTION ast_helpers.fields;

COMMIT;
