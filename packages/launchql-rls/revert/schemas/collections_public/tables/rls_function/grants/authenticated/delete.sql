-- Revert: schemas/collections_public/tables/rls_function/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE launchql_rls_collections_public.rls_function FROM authenticated;
COMMIT;  

