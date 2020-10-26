-- Deploy: schemas/collections_public/tables/procedure/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/procedure/table
-- requires: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.procedure
    ENABLE ROW LEVEL SECURITY;
COMMIT;
