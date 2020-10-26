-- Revert: schemas/collections_public/tables/field/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE launchql_rls_collections_public.field FROM authenticated;
COMMIT;  

