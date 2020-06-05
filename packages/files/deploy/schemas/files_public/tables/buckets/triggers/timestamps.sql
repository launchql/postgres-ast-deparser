-- Deploy schemas/files_public/tables/buckets/triggers/timestamps to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table

BEGIN;

ALTER TABLE files_public.buckets ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE files_public.buckets ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE files_public.buckets ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE files_public.buckets ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_files_public_buckets_modtime
BEFORE UPDATE OR INSERT ON files_public.buckets
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
