-- Deploy: schemas/collections_public/tables/unique_constraint/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/unique_constraint/table
-- requires: schemas/collections_public/tables/trigger_function/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.unique_constraint
    ENABLE ROW LEVEL SECURITY;
COMMIT;
