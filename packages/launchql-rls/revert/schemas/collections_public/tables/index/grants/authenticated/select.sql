-- Revert: schemas/collections_public/tables/index/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE launchql_rls_collections_public.index FROM authenticated;
COMMIT;  

