-- Revert schemas/ast_helpers/procedures/verify from pg

BEGIN;

DROP FUNCTION ast_helpers.verify;

COMMIT;
