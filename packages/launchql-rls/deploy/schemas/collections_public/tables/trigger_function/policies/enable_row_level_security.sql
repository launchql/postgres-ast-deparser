-- Deploy: schemas/collections_public/tables/trigger_function/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger_function/table
-- requires: schemas/collections_public/tables/trigger/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.trigger_function
    ENABLE ROW LEVEL SECURITY;
COMMIT;
