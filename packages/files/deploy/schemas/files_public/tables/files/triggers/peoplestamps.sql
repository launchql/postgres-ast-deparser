-- Deploy schemas/files_public/tables/files/triggers/peoplestamps to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/files/table

BEGIN;

ALTER TABLE files_public.files ADD COLUMN created_by UUID;
ALTER TABLE files_public.files ADD COLUMN updated_by UUID;

CREATE TRIGGER update_files_public_files_moduser
BEFORE UPDATE OR INSERT ON files_public.files
FOR EACH ROW
EXECUTE PROCEDURE tg_update_peoplestamps();

COMMIT;
