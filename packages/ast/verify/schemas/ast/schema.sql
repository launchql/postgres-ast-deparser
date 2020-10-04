-- Verify schemas/ast/schema  on pg

BEGIN;

SELECT verify_schema ('ast');

ROLLBACK;
