-- Deploy schemas/collections_public/tables/unique_constraint/policies/enable_row_level_security to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/unique_constraint/table

BEGIN;

ALTER TABLE collections_public.unique_constraint
    ENABLE ROW LEVEL SECURITY;

COMMIT;
