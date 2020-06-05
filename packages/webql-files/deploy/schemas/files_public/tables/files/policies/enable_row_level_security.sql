-- Deploy schemas/files_public/tables/files/policies/enable_row_level_security to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/files/table

BEGIN;

ALTER TABLE files_public.files
    ENABLE ROW LEVEL SECURITY;

COMMIT;
