-- Revert schemas/files_public/tables/files/triggers/timestamps from pg

BEGIN;

ALTER TABLE files_public.files DROP COLUMN created_at;
ALTER TABLE files_public.files DROP COLUMN updated_at;
DROP TRIGGER update_files_public_files_modtime ON files_public.files;

COMMIT;
