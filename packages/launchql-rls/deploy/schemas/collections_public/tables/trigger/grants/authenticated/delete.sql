-- Deploy: schemas/collections_public/tables/trigger/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger/table
-- requires: schemas/collections_public/tables/trigger/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE collections_public.trigger TO authenticated;
COMMIT;
