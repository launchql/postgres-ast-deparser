-- Deploy schemas/files_public/tables/buckets/policies/enable_row_level_security to pg

-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table

BEGIN;

ALTER TABLE files_public.buckets
    ENABLE ROW LEVEL SECURITY;

COMMIT;
