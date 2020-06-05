-- Verify schemas/files_public/tables/files/table on pg

BEGIN;

SELECT verify_table ('files_public.files');

ROLLBACK;
