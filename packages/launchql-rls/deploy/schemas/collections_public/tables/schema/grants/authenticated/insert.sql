-- Deploy: schemas/collections_public/tables/schema/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema/table
-- requires: schemas/collections_public/tables/schema/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.schema TO authenticated;
COMMIT;
