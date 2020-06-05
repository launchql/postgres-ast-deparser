-- Deploy schemas/collections_public/tables/constraint/policies/enable_row_level_security to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/constraint/table

BEGIN;

ALTER TABLE collections_public.constraint
    ENABLE ROW LEVEL SECURITY;

COMMIT;
