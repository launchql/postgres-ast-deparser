-- Revert schemas/ast_helpers/procedures/permissions from pg

BEGIN;

DROP FUNCTION ast_helpers.permissions;

COMMIT;
