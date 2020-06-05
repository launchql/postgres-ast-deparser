-- Verify schemas/collections_public/tables/constraint/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collections_public.constraint');

ROLLBACK;
