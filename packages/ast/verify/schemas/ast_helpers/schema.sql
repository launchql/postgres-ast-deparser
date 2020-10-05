-- Verify schemas/ast_helpers/schema  on pg

BEGIN;

SELECT verify_schema ('ast_helpers');

ROLLBACK;
