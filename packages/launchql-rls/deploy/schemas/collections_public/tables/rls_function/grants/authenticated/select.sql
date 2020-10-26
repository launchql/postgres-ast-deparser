-- Deploy: schemas/collections_public/tables/rls_function/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/rls_function/table
-- requires: schemas/collections_public/tables/rls_function/policies/authenticated_can_delete_on_rls_function

BEGIN;
GRANT SELECT ON TABLE collections_public.rls_function TO authenticated;
COMMIT;
