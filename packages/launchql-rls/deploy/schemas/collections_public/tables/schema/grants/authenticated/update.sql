-- Deploy: schemas/collections_public/tables/schema/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema/table
-- requires: schemas/collections_public/tables/schema/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE collections_public.schema TO authenticated;
COMMIT;
