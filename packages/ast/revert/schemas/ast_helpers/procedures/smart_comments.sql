-- Revert schemas/ast_helpers/procedures/smart_comments from pg

BEGIN;

DROP FUNCTION ast_helpers.smart_comments;

COMMIT;
