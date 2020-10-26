-- Deploy: schemas/collections_public/tables/field/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/field/table
-- requires: schemas/collections_public/tables/field/policies/authenticated_can_delete_on_field

BEGIN;
GRANT SELECT ON TABLE collections_public.field TO authenticated;
COMMIT;
