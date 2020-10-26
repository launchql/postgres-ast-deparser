-- Deploy: schemas/collections_public/tables/table_grant/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table_grant/table
-- requires: schemas/collections_public/tables/table_grant/policies/authenticated_can_delete_on_table_grant

BEGIN;
GRANT SELECT ON TABLE collections_public.table_grant TO authenticated;
COMMIT;
