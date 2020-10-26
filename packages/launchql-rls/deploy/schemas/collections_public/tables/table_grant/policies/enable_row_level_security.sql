-- Deploy: schemas/collections_public/tables/table_grant/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table_grant/table
-- requires: schemas/collections_public/tables/schema_grant/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.table_grant
    ENABLE ROW LEVEL SECURITY;
COMMIT;
