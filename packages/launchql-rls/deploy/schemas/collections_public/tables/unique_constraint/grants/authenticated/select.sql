-- Deploy: schemas/collections_public/tables/unique_constraint/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/unique_constraint/table
-- requires: schemas/collections_public/tables/unique_constraint/policies/authenticated_can_delete_on_unique_constraint

BEGIN;
GRANT SELECT ON TABLE collections_public.unique_constraint TO authenticated;
COMMIT;
