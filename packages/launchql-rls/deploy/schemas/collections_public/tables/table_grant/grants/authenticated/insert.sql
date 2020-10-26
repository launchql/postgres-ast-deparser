-- Deploy: schemas/collections_public/tables/table_grant/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table_grant/table
-- requires: schemas/collections_public/tables/table_grant/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.table_grant TO authenticated;
COMMIT;
