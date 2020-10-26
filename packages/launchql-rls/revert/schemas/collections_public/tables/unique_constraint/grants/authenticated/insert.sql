-- Revert: schemas/collections_public/tables/unique_constraint/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.unique_constraint FROM authenticated;
COMMIT;  

