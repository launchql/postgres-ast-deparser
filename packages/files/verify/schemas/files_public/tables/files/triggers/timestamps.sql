-- Verify schemas/files_public/tables/files/triggers/timestamps  on pg

BEGIN;

SELECT created_at FROM files_public.files LIMIT 1;
SELECT updated_at FROM files_public.files LIMIT 1;
SELECT verify_trigger ('files_public.update_files_public_files_modtime');

ROLLBACK;
