-- Verify schemas/deparser/procedures/deparse  on pg

BEGIN;

SELECT verify_function ('deparser.deparse');

ROLLBACK;
