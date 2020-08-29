-- Revert schemas/files_public/tables/buckets/triggers/timestamps from pg

BEGIN;

ALTER TABLE files_public.buckets DROP COLUMN created_at;
ALTER TABLE files_public.buckets DROP COLUMN updated_at;
DROP TRIGGER update_files_public_buckets_modtime ON files_public.buckets;

COMMIT;
