-- Verify schemas/collections_public/tables/foreign_key_constraint/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collections_public.foreign_key_constraint');

ROLLBACK;
