-- Verify schemas/ast_constants/schema  on pg

BEGIN;

SELECT verify_schema ('ast_constants');

ROLLBACK;
