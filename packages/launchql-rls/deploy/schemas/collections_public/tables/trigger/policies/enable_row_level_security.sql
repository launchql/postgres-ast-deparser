-- Deploy: schemas/collections_public/tables/trigger/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger/table
-- requires: schemas/collections_public/tables/table_grant/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.trigger
    ENABLE ROW LEVEL SECURITY;
COMMIT;
