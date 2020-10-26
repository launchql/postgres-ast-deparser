-- Deploy: schemas/collections_public/tables/trigger_function/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger_function/table
-- requires: schemas/collections_public/tables/trigger_function/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE collections_public.trigger_function TO authenticated;
COMMIT;
