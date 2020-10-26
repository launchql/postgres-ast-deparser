-- Revert: schemas/collections_public/tables/index/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.index FROM authenticated;
COMMIT;  

