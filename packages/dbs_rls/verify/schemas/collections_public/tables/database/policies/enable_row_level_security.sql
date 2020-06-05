-- Verify schemas/collections_public/tables/database/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('collections_public.database');

ROLLBACK;
