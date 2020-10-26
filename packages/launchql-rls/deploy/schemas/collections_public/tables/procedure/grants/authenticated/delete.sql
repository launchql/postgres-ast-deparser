-- Deploy: schemas/collections_public/tables/procedure/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/procedure/table
-- requires: schemas/collections_public/tables/procedure/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE collections_public.procedure TO authenticated;
COMMIT;
