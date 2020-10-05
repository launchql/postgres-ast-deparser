-- Revert schemas/ast_helpers/procedures/helpers from pg

BEGIN;

DROP FUNCTION ast_helpers.helpers;

COMMIT;
