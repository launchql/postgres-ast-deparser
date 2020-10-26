-- Revert: schemas/collections_public/tables/rls_function/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.rls_function FROM authenticated;
COMMIT;  

