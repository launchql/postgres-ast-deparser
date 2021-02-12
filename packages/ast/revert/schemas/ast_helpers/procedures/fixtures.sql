-- Revert schemas/ast_helpers/procedures/fixtures from pg

BEGIN;

DROP FUNCTION ast_helpers.fixtures;

COMMIT;
