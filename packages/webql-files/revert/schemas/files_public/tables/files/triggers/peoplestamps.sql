-- Revert schemas/files_public/tables/files/triggers/peoplestamps from pg

BEGIN;

ALTER TABLE files_public.files DROP COLUMN created_by;
ALTER TABLE files_public.files DROP COLUMN updated_by;
DROP TRIGGER update_files_public_files_moduser ON files_public.files;

COMMIT;
