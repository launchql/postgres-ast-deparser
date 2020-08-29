-- Revert schemas/files_public/tables/files/table from pg

BEGIN;

DROP TABLE files_public.files;

COMMIT;
