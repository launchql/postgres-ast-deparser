-- Revert: schemas/collections_public/tables/index/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.index FROM authenticated;
COMMIT;  

