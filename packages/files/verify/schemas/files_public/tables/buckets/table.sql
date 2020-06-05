-- Verify schemas/files_public/tables/buckets/table on pg

BEGIN;

SELECT verify_table ('files_public.buckets');

ROLLBACK;
