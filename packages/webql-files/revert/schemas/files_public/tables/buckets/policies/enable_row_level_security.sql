-- Revert schemas/files_public/tables/buckets/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE files_public.buckets
    DISABLE ROW LEVEL SECURITY;

COMMIT;
