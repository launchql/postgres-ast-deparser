-- Deploy: schemas/collections_public/tables/schema_grant/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema_grant/table
-- requires: schemas/collections_public/tables/schema_grant/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.schema_grant TO authenticated;
COMMIT;
