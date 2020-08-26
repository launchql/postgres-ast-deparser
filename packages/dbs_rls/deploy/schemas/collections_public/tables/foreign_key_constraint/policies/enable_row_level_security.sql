-- Deploy schemas/collections_public/tables/foreign_key_constraint/policies/enable_row_level_security to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/foreign_key_constraint/table

BEGIN;

ALTER TABLE collections_public.foreign_key_constraint
    ENABLE ROW LEVEL SECURITY;

COMMIT;
