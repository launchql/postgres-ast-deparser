-- Revert schemas/files_public/tables/buckets/triggers/peoplestamps from pg

BEGIN;

ALTER TABLE files_public.buckets DROP COLUMN created_by;
ALTER TABLE files_public.buckets DROP COLUMN updated_by;
DROP TRIGGER update_files_public_buckets_moduser ON files_public.buckets;

COMMIT;
