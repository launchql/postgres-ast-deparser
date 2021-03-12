-- Revert schemas/ast_helpers/procedures/rls from pg

BEGIN;

DROP FUNCTION ast_helpers.rls;

COMMIT;
