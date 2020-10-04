-- Verify schemas/deparser/schema  on pg

BEGIN;

SELECT verify_schema ('deparser');

ROLLBACK;
