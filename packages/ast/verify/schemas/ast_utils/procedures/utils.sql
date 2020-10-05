-- Verify schemas/ast_utils/procedures/utils  on pg

BEGIN;

SELECT verify_function ('ast_utils.utils');

ROLLBACK;
