-- Revert: schemas/collections_public/tables/foreign_key_constraint/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.foreign_key_constraint FROM authenticated;
COMMIT;  

