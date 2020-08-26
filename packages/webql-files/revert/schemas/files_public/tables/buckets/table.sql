-- Revert schemas/files_public/tables/buckets/table from pg

BEGIN;

DROP TABLE files_public.buckets;

COMMIT;
