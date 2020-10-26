-- Deploy: schemas/collections_public/tables/trigger/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger/table
-- requires: schemas/collections_public/tables/trigger/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.trigger TO authenticated;
COMMIT;
