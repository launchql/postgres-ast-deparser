-- Verify schemas/collections_public/tables/primary_key_constraint/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collections_public.primary_key_constraint');

ROLLBACK;
