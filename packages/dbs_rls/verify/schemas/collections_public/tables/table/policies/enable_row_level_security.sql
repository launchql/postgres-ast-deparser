-- Verify schemas/collections_public/tables/table/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collections_public.table');

ROLLBACK;
