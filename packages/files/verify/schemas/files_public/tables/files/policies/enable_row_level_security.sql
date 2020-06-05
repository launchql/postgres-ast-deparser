-- Verify schemas/files_public/tables/files/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('files_public.files');

ROLLBACK;
