-- Revert: schemas/collections_public/tables/rls_function/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.rls_function FROM authenticated;
COMMIT;  

