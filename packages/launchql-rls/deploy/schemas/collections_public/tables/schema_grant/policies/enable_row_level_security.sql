-- Deploy: schemas/collections_public/tables/schema_grant/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema_grant/table
-- requires: schemas/collections_public/tables/procedure/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.schema_grant
    ENABLE ROW LEVEL SECURITY;
COMMIT;
