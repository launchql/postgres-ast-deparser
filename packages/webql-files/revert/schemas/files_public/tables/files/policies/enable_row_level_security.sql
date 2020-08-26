-- Revert schemas/files_public/tables/files/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE files_public.files
    DISABLE ROW LEVEL SECURITY;

COMMIT;
