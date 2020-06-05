-- Verify schemas/files_public/tables/buckets/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('files_public.buckets');

ROLLBACK;
