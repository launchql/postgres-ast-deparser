-- Deploy: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/delete to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/primary_key_constraint/table
-- requires: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/update

BEGIN;
GRANT DELETE ON TABLE collections_public.primary_key_constraint TO authenticated;
COMMIT;
