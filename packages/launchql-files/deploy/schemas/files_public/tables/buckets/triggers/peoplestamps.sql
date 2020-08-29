-- Deploy schemas/files_public/tables/buckets/triggers/peoplestamps to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table

BEGIN;

ALTER TABLE files_public.buckets ADD COLUMN created_by UUID;
ALTER TABLE files_public.buckets ADD COLUMN updated_by UUID;

CREATE TRIGGER update_files_public_buckets_moduser
BEFORE UPDATE OR INSERT ON files_public.buckets
FOR EACH ROW
EXECUTE PROCEDURE tg_update_peoplestamps();

COMMIT;
