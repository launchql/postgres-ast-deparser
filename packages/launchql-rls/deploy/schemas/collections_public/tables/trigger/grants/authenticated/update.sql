-- Deploy: schemas/collections_public/tables/trigger/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger/table
-- requires: schemas/collections_public/tables/trigger/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE collections_public.trigger TO authenticated;
COMMIT;
