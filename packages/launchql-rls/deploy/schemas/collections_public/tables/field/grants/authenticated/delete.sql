-- Deploy: schemas/collections_public/tables/field/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/field/table
-- requires: schemas/collections_public/tables/field/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE collections_public.field TO authenticated;
COMMIT;
