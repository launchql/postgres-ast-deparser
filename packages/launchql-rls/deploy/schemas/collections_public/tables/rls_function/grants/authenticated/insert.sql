-- Deploy: schemas/collections_public/tables/rls_function/grants/authenticated/insert to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/rls_function/table
-- requires: schemas/collections_public/tables/rls_function/grants/authenticated/select

BEGIN;
GRANT INSERT ON TABLE collections_public.rls_function TO authenticated;
COMMIT;
