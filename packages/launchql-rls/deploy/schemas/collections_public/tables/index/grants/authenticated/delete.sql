-- Deploy: schemas/collections_public/tables/index/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/index/table
-- requires: schemas/collections_public/tables/index/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE collections_public.index TO authenticated;
COMMIT;
