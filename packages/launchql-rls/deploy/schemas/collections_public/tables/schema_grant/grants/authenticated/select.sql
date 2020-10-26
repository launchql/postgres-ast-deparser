-- Deploy: schemas/collections_public/tables/schema_grant/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema_grant/table
-- requires: schemas/collections_public/tables/schema_grant/policies/authenticated_can_delete_on_schema_grant

BEGIN;
GRANT SELECT ON TABLE collections_public.schema_grant TO authenticated;
COMMIT;
