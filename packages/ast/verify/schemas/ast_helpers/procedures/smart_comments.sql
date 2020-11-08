-- Verify schemas/ast_helpers/procedures/smart_comments  on pg

BEGIN;

SELECT verify_function ('ast_helpers.smart_comments');

ROLLBACK;
