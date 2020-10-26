-- Deploy: schemas/collections_public/tables/schema/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema/table
-- requires: schemas/collections_public/tables/schema/policies/authenticated_can_delete_on_schema

BEGIN;
GRANT SELECT ON TABLE collections_public.schema TO authenticated;
COMMIT;
