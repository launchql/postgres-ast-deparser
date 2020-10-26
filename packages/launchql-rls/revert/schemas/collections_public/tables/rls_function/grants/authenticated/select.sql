-- Revert: schemas/collections_public/tables/rls_function/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.rls_function FROM authenticated;
COMMIT;  

