-- Deploy schemas/collections_public/tables/table/policies/enable_row_level_security to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table

BEGIN;

ALTER TABLE collections_public.table
    ENABLE ROW LEVEL SECURITY;

COMMIT;
