-- Verify schemas/ast_utils/schema  on pg

BEGIN;

SELECT verify_schema ('ast_utils');

ROLLBACK;
