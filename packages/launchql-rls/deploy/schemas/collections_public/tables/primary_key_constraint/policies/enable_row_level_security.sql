-- Deploy: schemas/collections_public/tables/primary_key_constraint/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/primary_key_constraint/table
-- requires: schemas/collections_public/tables/policy/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.primary_key_constraint
    ENABLE ROW LEVEL SECURITY;
COMMIT;
