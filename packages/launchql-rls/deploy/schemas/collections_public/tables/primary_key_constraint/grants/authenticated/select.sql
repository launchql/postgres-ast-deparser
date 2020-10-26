-- Deploy: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/primary_key_constraint/table
-- requires: schemas/collections_public/tables/primary_key_constraint/policies/authenticated_can_delete_on_primary_key_constraint

BEGIN;
GRANT SELECT ON TABLE collections_public.primary_key_constraint TO authenticated;
COMMIT;
