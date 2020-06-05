-- Deploy schemas/files_public/tables/files/triggers/timestamps to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/files/table

BEGIN;

ALTER TABLE files_public.files ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE files_public.files ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE files_public.files ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE files_public.files ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_files_public_files_modtime
BEFORE UPDATE OR INSERT ON files_public.files
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
