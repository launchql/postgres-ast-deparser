-- Revert: schemas/collections_public/tables/unique_constraint/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE launchql_rls_collections_public.unique_constraint FROM authenticated;
COMMIT;  

