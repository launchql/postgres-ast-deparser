-- Deploy: schemas/collections_public/tables/field/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/field/table
-- requires: schemas/collections_public/tables/unique_constraint/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.field
    ENABLE ROW LEVEL SECURITY;
COMMIT;
