-- Deploy: schemas/collections_public/tables/index/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/index/table
-- requires: schemas/collections_public/tables/index/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE collections_public.index TO authenticated;
COMMIT;