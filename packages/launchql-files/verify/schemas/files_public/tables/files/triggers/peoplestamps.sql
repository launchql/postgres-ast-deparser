-- Verify schemas/files_public/tables/files/triggers/peoplestamps  on pg

BEGIN;

SELECT created_by FROM files_public.files LIMIT 1;
SELECT updated_by FROM files_public.files LIMIT 1;
SELECT verify_trigger ('files_public.update_files_public_files_moduser');

ROLLBACK;
