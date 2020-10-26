-- Deploy: schemas/collections_public/tables/rls_function/grants/authenticated/update to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/rls_function/table
-- requires: schemas/collections_public/tables/rls_function/grants/authenticated/insert

BEGIN;
GRANT UPDATE ON TABLE collections_public.rls_function TO authenticated;
COMMIT;
