-- Deploy: schemas/collections_public/tables/foreign_key_constraint/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/foreign_key_constraint/table
-- requires: schemas/collections_public/tables/schema/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.foreign_key_constraint
    ENABLE ROW LEVEL SECURITY;
COMMIT;
