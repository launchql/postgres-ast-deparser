-- Revert schemas/ast_constants/procedures/constants from pg

BEGIN;

DROP FUNCTION ast_constants.constants;

COMMIT;
