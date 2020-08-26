-- Verify schemas/collections_public/tables/unique_constraint/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collections_public.unique_constraint');

ROLLBACK;
