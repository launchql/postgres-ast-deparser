-- Deploy: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/primary_key_constraint/table
-- requires: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.primary_key_constraint TO authenticated;
COMMIT;
