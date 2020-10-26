-- Revert: schemas/collections_public/tables/primary_key_constraint/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.primary_key_constraint FROM authenticated;
COMMIT;  

