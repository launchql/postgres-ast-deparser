-- Revert schemas/ast_utils/procedures/utils from pg

BEGIN;

DROP FUNCTION ast_utils.utils;

COMMIT;
